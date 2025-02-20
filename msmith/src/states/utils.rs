use crate::{
    move_ast::MoveAST,
    states::{CurrScope, GenerationConfig, Id, IdKind, IdPool, Scope, Type, TypePool},
};
use framework::StatePool;

pub fn get_config(env: &StatePool<MoveAST>) -> &GenerationConfig {
    env.get::<GenerationConfig>().unwrap()
}

pub fn get_type_pool(env: &StatePool<MoveAST>) -> &TypePool {
    env.get::<TypePool>().unwrap()
}

pub fn get_id_pool(env: &StatePool<MoveAST>) -> &IdPool {
    env.get::<IdPool>().unwrap()
}

pub fn get_curr_scope(env: &StatePool<MoveAST>) -> Scope {
    env.get::<CurrScope>().unwrap().get()
}

pub fn pop_scope(env: &mut StatePool<MoveAST>) {
    env.get_mut::<CurrScope>().unwrap().pop();
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

pub fn new_id(env: &mut StatePool<MoveAST>, id_kind: IdKind, parent_scope: &Scope) -> (Id, Scope) {
    env.get_mut::<IdPool>()
        .unwrap()
        .next_id(id_kind, parent_scope)
}

pub fn new_id_from_curr_scope(env: &mut StatePool<MoveAST>, id_kind: IdKind) -> (Id, Scope) {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    new_id(env, id_kind, &curr_scope)
}

pub fn get_vars_in_curr_scope(env: &StatePool<MoveAST>) -> Vec<Id> {
    let curr_scope = env.get::<CurrScope>().unwrap().get();
    let id_pool = env.get::<IdPool>().unwrap();
    let all_ids = id_pool.get_ids_of_ident_kind(IdKind::Var);
    id_pool.filter_id_in_scope(&all_ids, &curr_scope)
}

pub fn get_vars_in_curr_scope_of_type(env: &StatePool<MoveAST>, typ: Option<&Type>) -> Vec<Id> {
    let ids = get_vars_in_curr_scope(env);
    let type_pool = get_type_pool(env);
    if let Some(typ) = typ {
        ids.into_iter()
            .filter(|id| {
                if let Some(var_type) = type_pool.get_var_type(id) {
                    var_type == *typ
                } else {
                    false
                }
            })
            .collect()
    } else {
        ids
    }
}
