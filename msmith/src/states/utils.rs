//! Helper functions for accessing and operating on common states

use crate::{
    move_ast::{MoveAST, Pattern, PatternKind},
    states::{
        types::{EnumType, EnumVariantType, GenericType, Type},
        CurrScope, Depth, GenerationConfig, Id, IdKind, IdPool, Named, NamedInfoPool, PerFuncInfo,
        PerModuleInfo, PerTestInfo, Scope, TypeSelector, FunctionKind,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::StatePool;
use log::trace;

#[inline]
pub fn get_config(env: &StatePool<MoveAST>) -> &GenerationConfig {
    env.get::<GenerationConfig>().unwrap()
}

#[inline]
pub fn get_config_mut(env: &mut StatePool<MoveAST>) -> &mut GenerationConfig {
    env.get_mut::<GenerationConfig>().unwrap()
}

#[inline]
pub fn get_named_infos(env: &StatePool<MoveAST>) -> &NamedInfoPool {
    env.get::<NamedInfoPool>().unwrap()
}

#[inline]
pub fn get_named_infos_mut(env: &mut StatePool<MoveAST>) -> &mut NamedInfoPool {
    env.get_mut::<NamedInfoPool>().unwrap()
}

#[inline]
pub fn get_id_pool(env: &StatePool<MoveAST>) -> &IdPool {
    env.get::<IdPool>().unwrap()
}

#[inline]
pub fn get_id_pool_mut(env: &mut StatePool<MoveAST>) -> &mut IdPool {
    env.get_mut::<IdPool>().unwrap()
}

#[inline]
pub fn get_curr_scope(env: &StatePool<MoveAST>) -> Scope {
    env.get::<CurrScope>().unwrap().get()
}

#[inline]
pub fn get_current_info(env: &StatePool<MoveAST>) -> &PerFuncInfo {
    env.get::<PerFuncInfo>().unwrap()
}

#[inline]
pub fn get_per_module_info(env: &StatePool<MoveAST>) -> &PerModuleInfo {
    env.get::<PerModuleInfo>().unwrap()
}

#[inline]
pub fn is_generating_script(env: &StatePool<MoveAST>) -> bool {
    env.get::<PerTestInfo>().unwrap().generating_script
}

#[inline]
pub fn push_scope(env: &mut StatePool<MoveAST>, scope: Scope) {
    env.get_mut::<CurrScope>().unwrap().push(scope);
}

#[inline]
pub fn pop_scope(env: &mut StatePool<MoveAST>) {
    env.get_mut::<CurrScope>().unwrap().pop();
}

#[inline]
pub fn reached_max_expr_depth(env: &StatePool<MoveAST>) -> bool {
    env.get::<Depth>().unwrap().expr_depth.reached_depth_limit()
}

#[inline]
pub fn almost_reached_max_expr_depth(env: &StatePool<MoveAST>, increment: usize) -> bool {
    env.get::<Depth>()
        .unwrap()
        .expr_depth
        .will_reached_depth_limit(increment)
}

#[inline]
pub fn is_in_spec(env: &StatePool<MoveAST>) -> bool {
    env.get::<PerModuleInfo>().unwrap().in_spec
}

/// Create a new id from the current scope and use the new scope as current scope
/// Returns (new id, new scope, old scope)
pub fn new_id_from_curr_scope_and_push_scope(
    env: &mut StatePool<MoveAST>,
    id_kind: IdKind,
) -> (Id, Scope, Scope) {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    let (name, new_scope) = new_id_and_push_scope(env, id_kind, &curr_scope);
    (name, new_scope, curr_scope)
}

pub fn new_id_and_push_scope(
    env: &mut StatePool<MoveAST>,
    id_kind: IdKind,
    parent_scope: &Scope,
) -> (Id, Scope) {
    let (name, scope) = new_id(env, id_kind, parent_scope);
    env.get_mut::<CurrScope>().unwrap().push(scope.clone());
    (name, scope)
}

#[inline]
pub fn new_id(env: &mut StatePool<MoveAST>, id_kind: IdKind, parent_scope: &Scope) -> (Id, Scope) {
    env.get_mut::<IdPool>()
        .unwrap()
        .next_id(id_kind, parent_scope)
}

pub fn new_id_from_curr_scope(env: &mut StatePool<MoveAST>, id_kind: IdKind) -> (Id, Scope) {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    new_id(env, id_kind, &curr_scope)
}

pub fn get_patterns_for_type(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    typ: &Type,
    scope: &Scope,
) -> Vec<Pattern> {
    let mut patterns = vec![];
    let cross_mod = !scope.is_from_same_module(&typ.name().get_self_scope());

    match typ {
        Type::Concrete(ct) => {
            patterns = get_patterns_for_type(u, env, &ct.get_concretized_type(), scope)
        },
        Type::Primitive(_) => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(GenericType::Tuple(t)) => {
            let field_patterns = t
                .types
                .iter()
                .map(|t| {
                    let pats = get_patterns_for_type(u, env, t, scope);
                    u.choose(&pats).unwrap().clone()
                })
                .collect();
            patterns.push(Pattern::new_full_positional(typ, field_patterns));
        },
        Type::Generic(GenericType::Struct(s)) if s.positional => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
            if !cross_mod {
                let field_patterns = s
                    .fields
                    .iter()
                    .map(|(_, t)| {
                        let pats = get_patterns_for_type(u, env, t, scope);
                        let partials = pats
                            .iter()
                            .filter_map(|pat| get_partial_patterns(u, pat))
                            .collect::<Vec<Pattern>>();
                        let all = pats.into_iter().chain(partials).collect::<Vec<Pattern>>();
                        u.choose(&all).unwrap().clone()
                    })
                    .collect::<Vec<Pattern>>();
                patterns.push(Pattern::new_full_positional(typ, field_patterns));
            }
        },
        Type::Generic(GenericType::Struct(s)) if !s.positional => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
            if !cross_mod {
                let field_patterns = s
                    .fields
                    .iter()
                    .map(|(name, t)| {
                        let pats = get_patterns_for_type(u, env, t, scope);
                        let partials = pats
                            .iter()
                            .filter_map(|pat| get_partial_patterns(u, pat))
                            .collect::<Vec<Pattern>>();
                        let all = pats.into_iter().chain(partials).collect::<Vec<Pattern>>();
                        (name.clone(), u.choose(&all).unwrap().clone())
                    })
                    .collect::<Vec<(Id, Pattern)>>();
                patterns.push(Pattern::new_named(typ, field_patterns, s.fields.len()));
            }
        },
        Type::Generic(GenericType::Enum(_)) => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(GenericType::Function(_)) => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Unit => {
            patterns.push(Pattern {
                body: PatternKind::Unit,
                typ: typ.clone(),
            });
        },
        Type::Generic(_) => {},
        _ => {},
    }
    patterns
}

/// Return ONE random partial patterns for the given position or named pattern.
/// TODO: maybe return all possible and choose later
pub fn get_partial_patterns(u: &mut Unstructured, pat: &Pattern) -> Option<Pattern> {
    trace!("Generating partial pattern for {pat:?}");
    match &pat.body {
        PatternKind::Positional(pats) => {
            if pats.is_empty() {
                return None;
            }
            let mut new_fields = pats.clone();
            let start_index = u.int_in_range(0..=new_fields.len() - 1).unwrap();
            let num_elems_left = new_fields.len() - start_index;
            let len = u.int_in_range(1..=num_elems_left).unwrap();
            for i in 0..len {
                let idx = start_index + i;
                if idx < new_fields.len() {
                    new_fields[idx] = None;
                }
            }
            Some(Pattern::new_partial_positional(&pat.typ, new_fields))
        },
        PatternKind::Named(pairs, num_total_fields) => {
            let mut new_paris = pairs.clone();
            let total = pairs.len();
            if total == 0 {
                return None;
            }
            let num_remove = if total == 1 {
                1
            } else {
                u.int_in_range(1..=total - 1).unwrap()
            };
            for _ in 0..num_remove {
                let idx = u.choose_index(new_paris.len()).unwrap();
                new_paris.remove(idx);
            }
            Some(Pattern::new_named(&pat.typ, new_paris, *num_total_fields))
        },
        _ => None,
    }
}

pub fn get_complete_patterns_for_enum(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    enum_type: EnumType,
    scope: &Scope,
) -> Vec<(Pattern, EnumVariantType, Scope)> {
    let mut output = vec![];
    for (_, variant) in &enum_type.variants {
        // Create a dummy block scope for each variant arm
        let (_, arm_scope) = new_id_and_push_scope(env, IdKind::Block, scope);

        let mut patterns = vec![];
        for (_, field_type) in &variant.fields {
            let pats = get_patterns_for_type(u, env, field_type, &arm_scope);
            let partials = pats
                .iter()
                .filter_map(|pat| get_partial_patterns(u, pat))
                .collect::<Vec<Pattern>>();
            let all_patterns = pats.into_iter().chain(partials).collect::<Vec<Pattern>>();
            patterns.push(u.choose(&all_patterns).unwrap().clone());
        }
        pop_scope(env);

        let variant_type = Type::Generic(GenericType::EnumVariant(variant.clone()));
        let arm_pattern = match &variant.positional {
            true => Pattern::new_full_positional(&variant_type, patterns),
            false => {
                let names_pats: Vec<(Id, Pattern)> = variant
                    .fields
                    .iter()
                    .zip(patterns.iter())
                    .map(|((name, _), pat)| (name.clone(), pat.clone()))
                    .collect();
                Pattern::new_named(&variant_type, names_pats, variant.fields.len())
            },
        };
        let partial_arm_pattern = get_partial_patterns(u, &arm_pattern);
        let chosen = match (partial_arm_pattern, bool::arbitrary(u).unwrap()) {
            (None, _) => arm_pattern,
            (Some(partial), true) => partial,
            (Some(_), false) => arm_pattern,
        };
        output.push((chosen, variant.clone(), arm_scope));
    }
    output
}

pub fn random_type_from_curr_scope(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    selectors: Vec<TypeSelector>,
) -> Result<Type> {
    let mod_info = get_per_module_info(env);
    let has_enum = mod_info.has_enum;
    let has_struct = mod_info.has_struct;
    let new_selectors = selectors
        .into_iter()
        .map(|mut s| {
            if !has_enum {
                s.enum_weight = 0;
            }
            if !has_struct {
                s.struct_weight = 0;
            }
            s
        })
        .collect();
    let curr_scope = get_curr_scope(env);
    let named_infos = get_named_infos(env);
    let mut chosen_type = named_infos.random_type(&curr_scope, u, new_selectors);
    if let Ok(Type::Generic(GenericType::Function(func_type))) = &mut chosen_type {
        let (func_name, _) = new_id_from_curr_scope(env, IdKind::Function(FunctionKind::Normal));
        func_type.name = func_name;
    }
    chosen_type
}
