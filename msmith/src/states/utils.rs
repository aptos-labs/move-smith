//! Helper functions for accessing and operating on common states

use crate::{
    move_ast::{DotVariable, MoveAST, Pattern, PatternKind, SingleVariable, Variable},
    states::{
        CurrScope, CurrentInfo, Depth, EnumType, EnumVariantType, GenerationConfig, GenericType,
        Id, IdKind, IdPool, InitMap, Scope, Type, TypePool, TypeSelector, Typed,
    },
};
use arbitrary::Unstructured;
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
pub fn get_type_pool(env: &StatePool<MoveAST>) -> &TypePool {
    env.get::<TypePool>().unwrap()
}

#[inline]
pub fn get_id_pool(env: &StatePool<MoveAST>) -> &IdPool {
    env.get::<IdPool>().unwrap()
}

#[inline]
pub fn get_curr_scope(env: &StatePool<MoveAST>) -> Scope {
    env.get::<CurrScope>().unwrap().get()
}

#[inline]
pub fn get_current_info(env: &StatePool<MoveAST>) -> &CurrentInfo {
    env.get::<CurrentInfo>().unwrap()
}

#[inline]
pub fn get_random_type(
    u: &mut Unstructured,
    env: &StatePool<MoveAST>,
    selector: &TypeSelector,
) -> Type {
    get_type_pool(env)
        .random_type(u, vec![selector.clone()])
        .unwrap()
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

pub fn get_all_dot_vars_from_rec(curr: DotVariable) -> Vec<DotVariable> {
    let curr_type = curr.ty();
    let fields = match &curr_type {
        Type::Generic(GenericType::Struct(s)) if !s.positional => &s.fields,
        Type::Generic(GenericType::Enum(e)) => &e.get_possible_named_fields(),
        _ => return vec![],
    };
    let mut dot_vars = vec![];
    for (field_name, field_type) in fields {
        let new_dot_var =
            DotVariable::new_with_prefix(&curr, (field_name.clone(), field_type.clone()));
        dot_vars.push(new_dot_var.clone());
        dot_vars.extend(get_all_dot_vars_from_rec(new_dot_var));
    }
    dot_vars
}

pub fn get_all_dot_vars_from(id: &Id, env: &StatePool<MoveAST>) -> Vec<DotVariable> {
    let id_typ = get_type_pool(env).get_var_type(id).unwrap();
    let id_dot = DotVariable::new(vec![(id.clone(), id_typ.clone())]);
    get_all_dot_vars_from_rec(id_dot)
}

pub fn get_initialized_vars_in_curr_scope_of_type(
    env: &StatePool<MoveAST>,
    wanted: Option<&Type>,
) -> Vec<Variable> {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    let id_pool = env.get::<IdPool>().unwrap();
    let all_ids = id_pool.get_ids_of_ident_kind(IdKind::Var);
    let ids = id_pool.filter_id_in_scope(&all_ids, &curr_scope);
    let ids = ids
        .into_iter()
        .filter(|id| env.get::<InitMap>().unwrap().is_var_initialized(id))
        .collect::<Vec<Id>>();

    let type_pool = env.get::<TypePool>().unwrap();

    let mut all_vars = vec![];
    for id in ids {
        let id_typ = type_pool.get_var_type(&id).unwrap();
        if Some(&id_typ) == wanted {
            all_vars.push(SingleVariable::new(&id, &id_typ).into());
        }

        match &id_typ {
            Type::Generic(GenericType::Enum(_)) | Type::Generic(GenericType::Struct(_)) => {
                let dot_vars = get_all_dot_vars_from(&id, env);
                for dot_var in dot_vars {
                    if Some(&dot_var.ty()) == wanted {
                        all_vars.push(dot_var.into());
                    }
                }
            },
            _ => {},
        }
    }
    all_vars
}

pub fn get_patterns_for_type(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    typ: &Type,
    scope: &Scope,
) -> Vec<Pattern> {
    let mut patterns = vec![];
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
            let field_patterns = s
                .fields
                .iter()
                .map(|(_, t)| {
                    let pats = get_patterns_for_type(u, env, t, scope);
                    u.choose(&pats).unwrap().clone()
                })
                .collect::<Vec<Pattern>>();
            patterns.push(Pattern::new_full_positional(typ, field_patterns));
        },
        Type::Generic(GenericType::Struct(s)) if !s.positional => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
            let field_patterns = s
                .fields
                .iter()
                .map(|(name, t)| {
                    let pats = get_patterns_for_type(u, env, t, scope);
                    (name.clone(), u.choose(&pats).unwrap().clone())
                })
                .collect::<Vec<(Id, Pattern)>>();
            patterns.push(Pattern::new_named(typ, field_patterns));
        },
        Type::Generic(GenericType::Enum(_)) => {
            let (name, _) = new_id(env, IdKind::Var, scope);
            patterns.push(Pattern::new_single_var(&name, typ));
        },
        Type::Generic(_) => {},
        _ => {},
    }
    patterns
}

/// Return ONE random partial patterns for the given position or named pattern.
/// TODO: maybe return all possible and choose later
pub fn get_partial_patterns(u: &mut Unstructured, pat: &Pattern) -> Option<Pattern> {
    trace!("Generating partial pattern for {:?}", pat);
    match &pat.body {
        PatternKind::Positional(pats) => {
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
        PatternKind::Named(pairs) => {
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
            Some(Pattern::new_named(&pat.typ, new_paris))
        },
        _ => None,
    }
}

pub fn get_complete_patterns_for_enum(
    u: &mut Unstructured,
    env: &mut StatePool<MoveAST>,
    enum_type: EnumType,
    scope: &Scope,
) -> Vec<(Vec<Pattern>, EnumVariantType, Scope)> {
    let mut output = vec![];
    for (_, variant) in &enum_type.variants {
        // Create a dummy block scope for each variant arm
        let (_, arm_scope) = new_id_and_push_scope(env, IdKind::Block, scope);

        let mut patterns = vec![];
        for (_, field_type) in &variant.fields {
            let pats = get_patterns_for_type(u, env, field_type, &arm_scope);
            let partials = patterns
                .iter()
                .filter_map(|pat| get_partial_patterns(u, pat));
            let all_patterns = pats.into_iter().chain(partials).collect::<Vec<Pattern>>();
            patterns.push(u.choose(&all_patterns).unwrap().clone());
        }
        pop_scope(env);

        output.push((patterns, variant.clone(), arm_scope));
    }
    output
}
