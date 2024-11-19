use crate::{
    ast::MoveAST,
    states::ids::{Scope, ROOT_SCOPE},
};
use arbitrary::Unstructured;
use framework::{GenLabel, Label, Labelled, Register, State, StateEntry, StateLabel};

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

impl Labelled for CurrScope {
    fn label() -> Label {
        StateLabel::new("CurrScope").into()
    }
}

impl Register<StateEntry> for CurrScope {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label().try_into().unwrap(),
            generators: vec![],
        }
    }
}

impl State<MoveAST> for CurrScope {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {}

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, _generator: &GenLabel) {}
}
