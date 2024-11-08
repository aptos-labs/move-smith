use arbitrary::Unstructured;
use framework::{
    ast::{ASTNode, Program},
    env::{State, StateT, STATES},
    label::{GenLabel, Label, Labelled, StateLabel},
    selection::RandomNumber,
};
use linkme::distributed_slice;

#[derive(Debug)]
pub struct NewState;

impl State for NewState {
    fn update_pre(&mut self, u: &mut Unstructured, _prog: &Program, _generator: &GenLabel) {
        unimplemented!()
    }

    fn update_post(
        &mut self,
        u: &mut Unstructured,
        prog: &Program,
        new_ast: &ASTNode,
        generator: &GenLabel,
    ) {
        unimplemented!()
    }

    fn as_any(&self) -> &dyn std::any::Any {
        self
    }

    fn as_any_mut(&mut self) -> &mut dyn std::any::Any {
        self
    }
}

impl Labelled for NewState {
    fn label() -> Label {
        Label::State(StateLabel::new("NewState"))
    }
}

#[distributed_slice(STATES)]
fn register_state() -> (StateLabel, StateT, Vec<GenLabel>) {
    (StateLabel::new("NewState"), Box::new(NewState), vec![])
}
