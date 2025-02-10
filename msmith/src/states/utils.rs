use crate::{
    move_ast::MoveAST,
    states::{CurrScope, GenerationConfig, Id, IdKind, IdPool, Scope, TypePool},
};
use framework::StatePool;

pub fn get_config(env: &StatePool<MoveAST>) -> &GenerationConfig {
    env.get::<GenerationConfig>().unwrap()
}

pub fn get_type_pool(env: &StatePool<MoveAST>) -> &TypePool {
    env.get::<TypePool>().unwrap()
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
