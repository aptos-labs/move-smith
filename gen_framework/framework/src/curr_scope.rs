use crate::{
    ast::{ASTNode, Program},
    env::{State, StateT, STATES},
    ids::{Scope, ROOT_SCOPE},
    label::{GenLabel, Label, Labelled, StateLabel},
};
use arbitrary::Unstructured;
use linkme::distributed_slice;

#[derive(Debug, Default)]
pub struct CurrScope {
    scopes: Vec<Scope>,
}

impl CurrScope {
    pub fn get(&self) -> Scope {
        self.scopes.last().unwrap_or(&ROOT_SCOPE).clone()
    }

    pub fn push(&mut self, scope: Scope) {
        self.scopes.push(scope);
    }

    pub fn pop(&mut self) {
        self.scopes.pop();
    }
}

impl State for CurrScope {
    fn update_pre(&mut self, _u: &mut Unstructured, _prog: &Program, _generator: &GenLabel) {}

    fn update_post(
        &mut self,
        _u: &mut Unstructured,
        _prog: &Program,
        _new_ast: &ASTNode,
        _generator: &GenLabel,
    ) {
    }

    fn as_any(&self) -> &dyn std::any::Any {
        self
    }

    fn as_any_mut(&mut self) -> &mut dyn std::any::Any {
        self
    }
}

impl Labelled for CurrScope {
    fn label() -> Label {
        Label::State(StateLabel::new("CurrScope"))
    }
}

#[distributed_slice(STATES)]
fn register_state() -> (StateLabel, StateT, Vec<GenLabel>) {
    (
        StateLabel::new("CurrScope"),
        Box::new(CurrScope::default()),
        vec![],
    )
}
