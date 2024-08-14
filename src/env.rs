// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Manages the various information during generation

use crate::{
    ast::FunctionSignature,
    config::GenerationConfig,
    names::{Identifier, IdentifierKind as IDKind, IdentifierPool, Scope},
    selection::RandomNumber,
    types::{Type, TypePool},
};
use arbitrary::Unstructured;
use log::trace;
use std::collections::{BTreeMap, BTreeSet};

/// The meta store for all the information during generation
#[derive(Debug)]
pub struct Env {
    pub config: GenerationConfig,
    pub id_pool: IdentifierPool,
    pub type_pool: TypePool,
    pub live_vars: LiveVarPool,

    /// For controlling the depth of the generated expressions/types
    pub expr_depth: DepthRing,
    pub type_depth: DepthRing,

    /// Timeout
    start_time: std::time::Instant,
    timeout: std::time::Duration,

    /// Inline function counter
    inline_func_counter: usize,

    /// Number of fields that has type of another struct
    struct_type_field_counter: usize,

    pub curr_func_signature: Option<FunctionSignature>,
}

/// A ring buffer to keep track of the max depth of expression/types.
/// We randomly generate a bunch of depths in the beginning and round-robin through them.
/// The goal is to potentially use a very huge depth occasionally but not always, since
/// it will make generation & compilation very slow.
/// We also don't want to generate a new random number every time we need a depth since
/// it's too costly both in terms of computation and input consumption.
///
/// To make things easier, we also just keep track of current generation depth here.
///
/// Also, during some phases of generation, we need to manually set the depth.
/// Such manual set will override the round-robin selection.
#[derive(Debug)]
pub struct DepthRing {
    /// The name of the depth, used for logging
    name: String,

    /// The list of max depths candidates
    max_depths: Vec<usize>,
    /// The current index of the max depth
    max_depth_idx: usize,

    /// The current depth of the generation
    curr_depth: usize,

    /// If a manual max depth is set
    manual_set: bool,
    /// The history of manual depths, for easy restoration
    manual_depth_history: Vec<usize>,
}

impl DepthRing {
    pub fn new(name: String) -> Self {
        Self {
            name,
            max_depths: vec![],
            max_depth_idx: 0,
            curr_depth: 0,
            manual_set: false,
            manual_depth_history: vec![],
        }
    }

    /// Initialize a new DepthRing with `num_depths` random depths
    pub fn initialize(&mut self, num_depths: usize, rng: &RandomNumber, u: &mut Unstructured) {
        let depths = (0..num_depths)
            .map(|_| rng.select(u).unwrap())
            .collect::<Vec<_>>();
        self.max_depths = depths;
    }

    /// Get the current max depth limit
    /// If a manual depth is set, return the last manual depth
    /// If not, return the current round-robin depth
    #[inline]
    fn get_curr_max_depth_limit(&self) -> usize {
        if self.manual_set {
            self.manual_depth_history.last().copied().unwrap()
        } else {
            self.max_depths[self.max_depth_idx]
        }
    }

    /// Move to the next depth limit in the round-robin fashion
    fn move_to_next_depth_limit(&mut self) {
        self.max_depth_idx = (self.max_depth_idx + 1) % self.max_depths.len();
        trace!(
            "using new {} depth: {}",
            self.name,
            self.get_curr_max_depth_limit()
        );
    }

    /// Check if the current generation has reached the depth
    pub fn reached_depth_limit(&self) -> bool {
        self.curr_depth() >= self.get_curr_max_depth_limit()
    }

    /// Check if the current generation will reach the depth with `inc` more steps
    pub fn will_reached_depth_limit(&self, inc: usize) -> bool {
        self.curr_depth() + inc >= self.get_curr_max_depth_limit()
    }

    /// Return the current depth
    #[inline]
    pub fn curr_depth(&self) -> usize {
        self.curr_depth
    }

    /// Increase the current depth by 1
    pub fn increase_depth(&mut self) {
        self.curr_depth += 1;
        trace!("Increment {} depth to: {}", self.name, self.curr_depth());
    }

    /// Decrease the current depth by 1
    /// If we reach the end of some generation step (depth becomes 0), we can use the next depth
    pub fn decrease_depth(&mut self) {
        self.curr_depth -= 1;
        trace!("Decrement {} depth to: {}", self.name, self.curr_depth());
        // We reach the end of some generation step, we can use the next depth
        if self.curr_depth() == 0 && !self.manual_set {
            self.move_to_next_depth_limit();
        }
    }

    /// Set a temporary maximum depth.
    pub fn set_max_depth(&mut self, max_depth: usize) {
        self.manual_depth_history.push(max_depth);
        self.manual_set = true;
    }

    /// Restore the maximum depth to the previous value.
    pub fn reset_max_depth(&mut self) {
        self.manual_depth_history.pop();
        self.manual_set = !self.manual_depth_history.is_empty();
    }
}

/// NOTE: This is unused for now to avoid the situation where the fuzzer cannot
/// find any expression for a type. Now everything is copy+drop.
///
/// Keep track of if a variable is still alive within a certain scope
///
/// If a variable might be dead, it is dead.
/// e.g. if a variable is consumer in one branch of an ITE, it is considered used.
#[derive(Debug, Default)]
pub struct LiveVarPool {
    scopes: BTreeMap<Scope, BTreeSet<Identifier>>,
}

impl LiveVarPool {
    /// Create am empty LiveVarPool
    pub fn new() -> Self {
        Self {
            scopes: BTreeMap::new(),
        }
    }

    /// Check if an identifier is still alive in any parent scope
    pub fn is_live(&self, scope: &Scope, id: &Identifier) -> bool {
        scope
            .ancestors()
            .iter()
            .rev()
            .any(|s| self.is_live_curr(s, id))
    }

    /// Check if an identifier is still alive strictly in the given scope
    pub fn is_live_curr(&self, scope: &Scope, id: &Identifier) -> bool {
        self.scopes.get(scope).map_or(false, |s| s.contains(id))
    }

    /// Filter out non-live identifiers
    pub fn filter_live_vars(&self, scope: &Scope, ids: Vec<Identifier>) -> Vec<Identifier> {
        ids.into_iter()
            .filter(|id| self.is_live(scope, id))
            .collect()
    }

    /// Mark an identifier as alive in the given scope and all its parent scopes
    pub fn mark_alive(&mut self, scope: &Scope, id: &Identifier) {
        trace!("Marking {:?} as alive in {:?}", id, scope);
        let live_vars = self.scopes.entry(scope.clone()).or_default();
        live_vars.insert(id.clone());
    }

    /// Mark an identifier as dead
    pub fn mark_moved(&mut self, scope: &Scope, id: &Identifier) {
        trace!("Marking {:?} as moved in {:?}", id, scope);
        // The varibale is consumed at the given scope, but might be assigned
        // (marked alive) at an earlier scope, so we need to check back.
        scope.ancestors().iter().for_each(|s| {
            if let Some(live_vars) = self.scopes.get_mut(s) {
                live_vars.remove(id);
            }
        });
    }
}

impl Env {
    /// Create a new environment with the given configuration
    pub fn new(config: &GenerationConfig) -> Self {
        Self {
            config: config.clone(),
            id_pool: IdentifierPool::new(),
            type_pool: TypePool::new(),
            live_vars: LiveVarPool::new(),

            expr_depth: DepthRing::new("expr".to_string()),
            type_depth: DepthRing::new("type".to_string()),

            start_time: std::time::Instant::now(),
            timeout: std::time::Duration::from_secs(config.generation_timeout_sec as u64),
            inline_func_counter: 0,
            struct_type_field_counter: 0,
            curr_func_signature: None,
        }
    }

    pub fn initialize(&mut self, u: &mut Unstructured) {
        self.expr_depth.initialize(10, &self.config.expr_depth, u);
        self.type_depth.initialize(10, &self.config.type_depth, u);
    }

    /// Check if the current generation has reached the timeout
    #[inline]
    pub fn check_timeout(&self) -> bool {
        self.start_time.elapsed() > self.timeout
    }

    /// Return a list of identifiers fileterd by the given type and scope
    /// `typ` should be the desired Move type
    /// `ident_type` should be the desired identifier type (e.g. var, func)
    /// `scope` should be the desired scope
    pub fn get_identifiers(
        &self,
        typ: Option<&Type>,
        ident_kind: Option<IDKind>,
        scope: Option<&Scope>,
    ) -> Vec<Identifier> {
        let mut ids = self.get_identifiers_all(typ, ident_kind, scope);
        ids.retain(|id| !matches!(self.type_pool.get_type(id), Some(Type::Vector(_))));
        ids
    }

    pub fn get_vector_identifiers(&self, typ: Option<&Type>, scope: &Scope) -> Vec<Identifier> {
        let mut ids = self.get_identifiers_all(typ, Some(IDKind::Var), Some(scope));
        ids.retain(|id| matches!(self.type_pool.get_type(id), Some(Type::Vector(_))));
        ids
    }

    fn get_identifiers_all(
        &self,
        typ: Option<&Type>,
        ident_kind: Option<IDKind>,
        scope: Option<&Scope>,
    ) -> Vec<Identifier> {
        trace!(
            "Getting identifiers with constraints: typ ({:?}), kind ({:?}), scope ({:?})",
            typ,
            ident_kind,
            scope,
        );

        // Filter based on the IDKind
        let all_ident = match ident_kind {
            Some(ref t) => self.id_pool.get_identifiers_of_ident_kind(t.clone()),
            None => self.id_pool.get_all_identifiers(),
        };
        trace!(
            "After filtering identifier kind {:?}, {} identifiers remined",
            ident_kind,
            all_ident.len()
        );

        // Filter based on Scope
        let ident_in_scope = match scope {
            Some(s) => self.id_pool.filter_identifier_in_scope(&all_ident, s),
            None => all_ident,
        };
        trace!(
            "After filtering scope {:?}, {} identifiers remined",
            scope,
            ident_in_scope.len()
        );

        // Filter based on Type
        let type_matched = match typ {
            Some(t) => self
                .type_pool
                .filter_identifier_with_type(t, ident_in_scope),
            None => ident_in_scope,
        };
        trace!(
            "After filtering type {:?}, {} identifiers remined",
            typ,
            type_matched.len()
        );

        // Filter out the identifiers that do not have a type
        // i.e. the one just declared but the RHS of assign is not finished yet
        type_matched
            .into_iter()
            .filter(|id: &Identifier| self.type_pool.get_type(id).is_some())
            .collect()
    }

    /// Return the list of live variables of type `typ` in the given scope
    pub fn live_variables(&self, scope: &Scope, typ: Option<&Type>) -> Vec<Identifier> {
        let ids = self.get_identifiers(typ, Some(IDKind::Var), Some(scope));
        self.live_vars.filter_live_vars(scope, ids)
    }

    #[inline]
    pub fn inc_inline_func_counter(&mut self) {
        self.inline_func_counter += 1;
    }

    #[inline]
    pub fn reached_inline_function_limit(&mut self, u: &mut Unstructured) -> bool {
        self.inline_func_counter >= self.config.num_inline_funcs.select_once(u).unwrap()
    }

    #[inline]
    pub fn inc_struct_type_field_counter(&mut self) {
        self.struct_type_field_counter += 1;
    }

    #[inline]
    pub fn reached_struct_type_field_limit(&mut self, u: &mut Unstructured) -> bool {
        self.struct_type_field_counter
            >= self
                .config
                .num_fields_of_struct_type
                .select_once(u)
                .unwrap()
    }
}
