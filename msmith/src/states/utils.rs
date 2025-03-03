//! Helper functions for accessing and operating on common states

use super::ExpressionDepth;
use crate::{
    move_ast::{DotVariable, MoveAST, SingleVariable, Variable},
    states::{
        CurrScope, GenerationConfig, GenericType, Id, IdKind, IdPool, Scope, Type, TypePool, Typed,
    },
};
use framework::StatePool;

#[inline]
pub fn get_config(env: &StatePool<MoveAST>) -> &GenerationConfig {
    env.get::<GenerationConfig>().unwrap()
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
pub fn pop_scope(env: &mut StatePool<MoveAST>) {
    env.get_mut::<CurrScope>().unwrap().pop();
}

#[inline]
pub fn reached_max_expr_depth(env: &StatePool<MoveAST>) -> bool {
    env.get::<ExpressionDepth>().unwrap().reached_max_depth()
}

#[inline]
pub fn almost_reached_max_expr_depth(env: &StatePool<MoveAST>, threshold: usize) -> bool {
    env.get::<ExpressionDepth>()
        .unwrap()
        .almost_reached_max_expr_depth(threshold)
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
    if let Type::Generic(GenericType::Struct(s)) = &curr_type {
        let mut dot_vars = vec![];
        for (field_name, field_type) in &s.fields {
            let new_dot_var =
                DotVariable::new_with_prefix(&curr, (field_name.clone(), field_type.clone()));
            dot_vars.push(new_dot_var.clone());
            dot_vars.extend(get_all_dot_vars_from_rec(new_dot_var));
        }
        dot_vars
    } else {
        vec![]
    }
}

pub fn get_all_dot_vars_from(id: &Id, env: &StatePool<MoveAST>) -> Vec<DotVariable> {
    let id_typ = get_type_pool(env).get_var_type(id).unwrap();
    let id_dot = DotVariable::new(vec![(id.clone(), id_typ.clone())]);
    get_all_dot_vars_from_rec(id_dot)
}

pub fn get_vars_in_curr_scope_of_type(
    env: &StatePool<MoveAST>,
    wanted: Option<&Type>,
) -> Vec<Variable> {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    let id_pool = env.get::<IdPool>().unwrap();
    let all_ids = id_pool.get_ids_of_ident_kind(IdKind::Var);
    let ids = id_pool.filter_id_in_scope(&all_ids, &curr_scope);

    let type_pool = env.get::<TypePool>().unwrap();

    let mut all_vars = vec![];
    for id in ids {
        let id_typ = type_pool.get_var_type(&id).unwrap();
        if Some(&id_typ) == wanted {
            all_vars.push(SingleVariable::new(&id, &id_typ).into());
        }

        if let Type::Generic(GenericType::Struct(_)) = &id_typ {
            let dot_vars = get_all_dot_vars_from(&id, env);
            for dot_var in dot_vars {
                if Some(&dot_var.ty()) == wanted {
                    all_vars.push(dot_var.into());
                }
            }
        }
    }
    all_vars
}
