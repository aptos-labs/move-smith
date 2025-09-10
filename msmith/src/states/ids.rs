// Copyright (c) Aptos Foundation
// SPDX-License-ID: Apache-2.0

//! Manages IDs and scope information during generation.

use crate::move_ast::MoveAST;
use arbitrary::Unstructured;
use core::panic;
use framework::{GenLabel, LabelledState, Register, State, StateEntry, StateLabel};
use log::trace;
use std::{collections::HashMap, fmt};

pub trait Named {
    fn name(&self) -> Id;

    fn parent_scope(&self) -> Scope {
        self.name().get_parent_scope()
    }

    fn self_scope(&self) -> Scope {
        self.name().get_self_scope()
    }

    fn full_name(&self) -> Scope {
        self.self_scope()
    }
}

/// Represents a Move Id.
/// Key invariant: each Id is globally unique.
/// This is achieved by appending a monotonic counter to the Id name.
#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Default)]
pub struct Id {
    pub name: String,
    pub kind: IdKind,
    /// The scope that this Id is created in
    pub parent_scope: Scope,
    /// The scope that this Id owns
    pub self_scope: Scope,
}

impl Id {
    pub fn new_without_scopes(name: &str, kind: IdKind) -> Self {
        Self {
            name: name.to_string(),
            kind,
            parent_scope: Scope::default(),
            self_scope: Scope::default(),
        }
    }

    pub fn new(name: String, kind: IdKind, parent_scope: Scope, self_scope: Scope) -> Self {
        Self {
            name,
            kind,
            parent_scope,
            self_scope,
        }
    }

    pub fn new_str(name: &str, kind: IdKind, parent_scope: Scope, self_scope: Scope) -> Self {
        Self {
            name: name.to_string(),
            kind,
            parent_scope,
            self_scope,
        }
    }

    pub fn full_name(&self) -> String {
        self.self_scope.get_name()
    }

    /// Merge a list of Ids into a dot separated name.
    /// The scopes and kind of the first Id in the list are used.
    pub fn merge_into_dot_name(ids: &[Self]) -> Self {
        assert!(!ids.is_empty(), "Cannot merge empty Ids");
        let kind = ids[0].kind.clone();
        let parent_scope = ids[0].parent_scope.clone();
        let self_scope = ids[0].self_scope.clone();

        let new_name = ids
            .iter()
            .map(|id| id.name.clone())
            .collect::<Vec<String>>()
            .join(".");

        Id::new(new_name, kind, parent_scope, self_scope)
    }

    pub fn get_parent_scope(&self) -> Scope {
        self.parent_scope.clone()
    }

    pub fn get_self_scope(&self) -> Scope {
        self.self_scope.clone()
    }

    /// Check if an Id is accessible in the given scope.
    pub fn is_in_scope(&self, scope: &Scope) -> bool {
        let parent = self.get_parent_scope();
        scope.is_in_scope(&parent)
    }

    /// Convert the Id to a scope.
    pub fn to_scope(&self) -> Scope {
        Scope(Some(self.name.clone()))
    }

    pub fn is_var(&self) -> bool {
        self.kind == IdKind::Var
    }

    pub fn is_func(&self) -> bool {
        matches!(self.kind, IdKind::Function(_))
    }

    pub fn is_normal_func(&self) -> bool {
        matches!(self.kind, IdKind::Function(FunctionKind::Normal))
    }

    pub fn is_producer_func(&self) -> bool {
        matches!(self.kind, IdKind::Function(FunctionKind::Producer))
    }

    pub fn is_runner_func(&self) -> bool {
        matches!(self.kind, IdKind::Function(FunctionKind::Runner))
    }

    pub fn get_function_kind(&self) -> Option<&FunctionKind> {
        match &self.kind {
            IdKind::Function(kind) => Some(kind),
            _ => None,
        }
    }

    pub fn is_struct(&self) -> bool {
        self.kind == IdKind::Struct
    }

    pub fn is_enum(&self) -> bool {
        self.kind == IdKind::Enum
    }
}

impl fmt::Display for Id {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.name)
    }
}

/// The types of functions.
#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Default)]
pub enum FunctionKind {
    #[default]
    Normal,
    Producer,
    Runner,
}

/// The types of IDs.
#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Default)]
pub enum IdKind {
    #[default]
    Var,
    Struct,
    Enum,
    EnumVariant,
    Function(FunctionKind),
    Module,
    Script,
    Constant,
    Type,
    TypeParameter,
    Field,
    Address,
    Lambda,

    // Block IDs are only used to keep track of scope.
    Block,
    
    // Spec block IDs
    Spec,
}

impl IdKind {
    pub fn from_name(name: &str) -> Self {
        match name {
            _ if name.starts_with("var") => IdKind::Var,
            _ if name.starts_with("Struct") => IdKind::Struct,
            _ if name.starts_with("Enum") => IdKind::Enum,
            _ if name.starts_with("Variant") => IdKind::EnumVariant,
            _ if name.starts_with("function") => IdKind::Function(FunctionKind::Normal),
            _ if name.starts_with("producer") => IdKind::Function(FunctionKind::Producer),
            _ if name.starts_with("runner") => IdKind::Function(FunctionKind::Runner),
            _ if name.starts_with("Module") => IdKind::Module,
            _ if name.starts_with("Script") => IdKind::Script,
            _ if name.starts_with("CONST") => IdKind::Constant,
            _ if name.starts_with("_type") => IdKind::Type,
            _ if name.starts_with('T') => IdKind::TypeParameter,
            _ if name.starts_with("field") => IdKind::Field,
            _ if name.starts_with("_block") => IdKind::Block,
            _ if name.starts_with("_address") => IdKind::Address,
            _ if name.starts_with("_lambda") => IdKind::Lambda,
            _ if name.starts_with("_spec") => IdKind::Spec,
            _ => panic!("Unknown Id kind: {}", name),
        }
    }

    pub fn get_kind_name(&self) -> String {
        match self {
            IdKind::Var => "var",
            IdKind::Struct => "Struct",
            IdKind::Enum => "Enum",
            IdKind::EnumVariant => "Variant",
            IdKind::Function(kind) => match kind {
                FunctionKind::Normal => "function",
                FunctionKind::Producer => "producer",
                FunctionKind::Runner => "runner",
            },
            IdKind::Module => "Module",
            IdKind::Script => "Script",
            IdKind::Constant => "Constant",
            IdKind::Type => "_type",
            IdKind::TypeParameter => "T",
            IdKind::Field => "field",
            IdKind::Block => "_block",
            IdKind::Address => "_address",
            IdKind::Lambda => "_lambda",
            IdKind::Spec => "_spec",
        }
        .to_string()
    }
}

/// Scope is the namespace where a variable can be accessed.
/// None: represents the root scope.
/// Some(scope): the scope must have the format "parent::child".
/// e.g. "Module1::function1"
#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord, Default)]
pub struct Scope(pub Option<String>);

impl Scope {
    /// Return if the scope is the root scope.
    pub fn is_root(&self) -> bool {
        self.0.is_none()
    }

    pub fn is_from_same_module(&self, other: &Scope) -> bool {
        if self.is_root() || other.is_root() {
            return false;
        }
        let self_pieces = self.to_pieces();
        let other_pieces = other.to_pieces();
        if self_pieces.len() < 2 || other_pieces.len() < 2 {
            return false;
        }

        // Scopes have format of Address::Module
        self_pieces[1] == other_pieces[1]
    }

    /// Returns true if `self` is the same as or within `scope`.
    /// e.g. (M1::F1::B1::B2).is_in_scope(M1::F1) ==> true
    ///
    /// To check whether you can access something defined in a given scope while you are at another scope,
    /// use `current_scope.is_in_scope(target_item.parent_scope())`
    ///
    /// e.g. You want to check whether you can access `M1::F1::B1::V1` in `M1::F1::B1::B2`
    ///     `(M1::F1::B1::B2).is_in_scope(M1::F1::B1)` ==> true ==> accessible
    /// e.g. You want to check whether you can access `M1::F1::B1::V1` in `M1::F2`
    ///     `(M1::F2).is_in_scope(M1::F1::B1)` ==> false ==> not accessible
    pub fn is_in_scope(&self, scope: &Scope) -> bool {
        match (&self.0, &scope.0) {
            (Some(c), Some(p)) => c == p || c.starts_with(&format!("{p}::")),
            (Some(_), None) => true,
            (None, Some(_)) => false,
            (None, None) => true,
        }
    }

    pub fn get_name(&self) -> String {
        self.0.clone().unwrap_or("".to_string())
    }

    /// Remove all hidden scopes whose name starts with an underscore
    /// e.g. `Module1::function1::_block1::_block2` will result in `Module1::function1`
    pub fn remove_hidden_scopes(&self) -> Scope {
        if self.is_root() {
            return self.clone();
        }

        let pieces = self.to_pieces();
        let new_scope = pieces
            .into_iter()
            .filter(|s| !s.starts_with('_'))
            .collect::<Vec<String>>()
            .join("::");
        Scope(Some(new_scope))
    }

    /// Split the scope into individual pieces.
    /// e.g., `Module1::function1::_block1::_block2` will result in
    /// `["Module1", "function1", "_block1", "_block2"]`
    pub fn to_pieces(&self) -> Vec<String> {
        match &self.0 {
            Some(name) => name.split("::").map(String::from).collect(),
            None => vec![],
        }
    }

    /// Get all parent scopes of the current scope, including self
    pub fn ancestors(&self) -> Vec<Scope> {
        let pieces = self.to_pieces();
        let mut parents = vec![ROOT_SCOPE.clone()];
        for i in 1..pieces.len() {
            let parent = pieces[0..i].join("::");
            parents.push(Scope(Some(parent)));
        }
        parents.push(self.clone());
        parents
    }

    /// Find the last lambda scope from self
    /// e.g. Module1::function1::_lambda1::_block1::_lambda2::_block2
    /// will return Some(Module1::function1::_lambda1::_block1::_lambda2
    pub fn get_nearest_lambda_scope(&self) -> Option<Scope> {
        let pieces = self.to_pieces();
        for i in (0..pieces.len()).rev() {
            if pieces[i].starts_with("_lambda") {
                let lambda_scope = pieces[0..=i].join("::");
                return Some(Scope(Some(lambda_scope)));
            }
        }
        None
    }
}

/// Represents the root scope.
pub const ROOT_SCOPE: Scope = Scope(None);

/// Keeps track of all used IDs and the scope information.
/// Each different kind of Id (var, struct, function, etc.) has its own counter.
/// The `scopes` map keeps track of the scope information for each Id.
/// Key invariant: each scope should be complete, meaning no chasing should be needed.
#[derive(Debug, Default)]
pub struct IdPool {
    all_ids: Vec<Id>,
    counters: HashMap<IdKind, usize>,
    scopes: HashMap<Id, Scope>,
}

impl IdPool {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn new_address(&mut self, address: &str) -> (Id, Scope) {
        let address_scope = Scope(Some(address.to_string()));
        let new_scope = self.merge_scopes(&ROOT_SCOPE, &address_scope);

        let new_id = Id::new_str(
            address,
            IdKind::Address,
            ROOT_SCOPE.clone(),
            new_scope.clone(),
        );
        self.insert_new_id(&IdKind::Address, new_id.clone());

        self.scopes.insert(new_id.clone(), ROOT_SCOPE.clone());
        trace!("Inserted new id: {new_id:?} under scope: {ROOT_SCOPE:?}");
        (new_id, new_scope)
    }

    /// Creates a new Id under the given scope.
    /// Returns the scope that this new Id owns.
    ///
    /// For example, to create a new function under a module `Module1`,
    /// `next_ID(..., Module1)` will return (function1, Module1::function1)
    /// Then to create a new local variable in function1,
    /// the call `next_ID(..., Module1::function1)` should be used.
    /// This should be followed during generation to maintain the scope hierarchy.
    // TODO: add extra check for the completeness of the scope
    pub fn next_id(&mut self, typ: IdKind, scope: &Scope) -> (Id, Scope) {
        let cnt = self.id_count(&typ);
        let name = self.construct_name(&typ, cnt);

        let child_scope = Scope(Some(name.clone()));
        let new_scope: Scope = self.merge_scopes(scope, &child_scope);

        let new_id = Id::new(name.clone(), typ.clone(), scope.clone(), new_scope.clone());
        self.insert_new_id(&typ, new_id.clone());

        self.scopes.insert(new_id.clone(), scope.clone());
        trace!("Inserted new id: {new_id:?} under scope: {scope:?}");
        (new_id, new_scope)
    }

    /// Get the outer most scope where the given Id is accessible.
    pub fn get_parent_scope_of(&self, id: &Id) -> Option<Scope> {
        self.scopes.get(id).cloned()
    }

    /// Get the scope where the children of the given Id are accessible.
    pub fn get_scope_for_children(&self, id: &Id) -> Scope {
        match self.scopes.get(id) {
            Some(scope) => self.merge_scopes(scope, &id.to_scope()),
            None => id.to_scope(),
        }
    }

    /// Check if an Id is accessible in the given scope.
    pub fn is_id_in_scope(&self, id: &Id, scope: &Scope) -> bool {
        let parent_of_id = self.get_parent_scope_of(id);
        match parent_of_id {
            Some(parent) => scope.is_in_scope(&parent),
            None => true,
        }
    }

    /// Check if an Id is accessible within another Id.
    /// The parent Id should be function, block, struct, etc.
    pub fn is_id_in_id(&self, child: &Id, parent: &Id) -> bool {
        let parent_scope = self.get_parent_scope_of(parent).unwrap();
        self.is_id_in_scope(child, &parent_scope)
    }

    /// Helper function to filter IDs that are in the given scope.
    pub fn filter_id_in_scope(&self, ids: &Vec<Id>, parent_scope: &Scope) -> Vec<Id> {
        let mut in_scope = Vec::new();
        for id in ids {
            if self.is_id_in_scope(id, parent_scope) {
                in_scope.push(id.clone());
            }
        }
        in_scope
    }

    /// Returns all IDs in use.
    pub fn get_all_ids(&self) -> Vec<Id> {
        self.scopes.keys().cloned().collect()
    }

    /// Returns all IDs of the given Id kind.
    /// e.g. get all function IDs.
    pub fn get_ids_of_ident_kind(&self, typ: IdKind) -> Vec<Id> {
        self.all_ids
            .iter()
            .filter(|id| id.kind == typ)
            .cloned()
            .collect()
    }

    /// Add a new Id to the pool.
    fn insert_new_id(&mut self, typ: &IdKind, id: Id) {
        self.counters
            .entry(typ.clone())
            .and_modify(|e| *e += 1)
            .or_insert(1);
        self.all_ids.push(id);
    }

    /// Get the count of IDs of the given type.
    fn id_count(&self, typ: &IdKind) -> usize {
        self.counters.get(typ).cloned().unwrap_or(0)
    }

    /// Create the name of an Id.
    fn construct_name(&self, typ: &IdKind, idx: usize) -> String {
        format!("{}{}", typ.get_kind_name(), idx)
    }

    fn merge_scopes(&self, parent: &Scope, child: &Scope) -> Scope {
        Scope(match (&parent.0, &child.0) {
            (Some(p), Some(c)) => Some(format!("{p}::{c}")),
            (Some(p), None) => Some(p.clone()),
            (None, Some(c)) => Some(c.clone()),
            (None, None) => None,
        })
    }
}

#[test]
fn test_scope() {
    let scope = Scope(Some("Module1::function1::_block1::_block2".to_string()));
    let pieces = scope.to_pieces();
    assert_eq!(pieces, vec!["Module1", "function1", "_block1", "_block2"]);
    let ans = scope.ancestors();
    assert_eq!(ans.len(), 5);
}

#[test]
fn test_id_type() {
    let mut id_pool = IdPool::new();

    let _ = id_pool.next_id(IdKind::Block, &ROOT_SCOPE);
    let _ = id_pool.next_id(IdKind::Block, &ROOT_SCOPE);
    let _ = id_pool.next_id(IdKind::Struct, &ROOT_SCOPE);

    let bids = id_pool.get_ids_of_ident_kind(IdKind::Block);
    println!("{bids:?}");
    assert!(bids.len() == 2);
    let sids = id_pool.get_ids_of_ident_kind(IdKind::Struct);
    assert!(sids.len() == 1);
}

impl LabelledState for IdPool {
    fn label() -> StateLabel {
        StateLabel::new("IdPool")
    }
}

impl Register<StateEntry> for IdPool {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![],
        }
    }
}

impl State<MoveAST> for IdPool {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, _generator: &GenLabel) {}
}
