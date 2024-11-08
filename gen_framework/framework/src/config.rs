use crate::{
    ast::{ASTNode, Program},
    env::{State, StateT, STATES},
    label::{GenLabel, Label, Labelled, StateLabel},
    selection::RandomNumber,
};
use arbitrary::Unstructured;
use linkme::distributed_slice;

#[derive(Debug)]
pub struct Config {
    pub num_structs: RandomNumber,
    pub num_funcs: RandomNumber,
    pub num_fields: RandomNumber,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            num_structs: RandomNumber::new(0, 2, 5),
            num_funcs: RandomNumber::new(0, 10, 20),
            num_fields: RandomNumber::new(0, 2, 5),
        }
    }
}

impl State for Config {
    fn update_pre(&mut self, _u: &mut Unstructured, _prog: &Program, _generator: &GenLabel) {
        // Do nothing
    }

    fn update_post(
        &mut self,
        _u: &mut Unstructured,
        _prog: &Program,
        _new_ast: &ASTNode,
        _generator: &GenLabel,
    ) {
        // Do nothing
    }

    fn as_any(&self) -> &dyn std::any::Any {
        self
    }

    fn as_any_mut(&mut self) -> &mut dyn std::any::Any {
        self
    }
}

impl Labelled for Config {
    fn label() -> Label {
        Label::State(StateLabel::new("Config"))
    }
}

#[distributed_slice(STATES)]
fn register_state() -> (StateLabel, StateT, Vec<GenLabel>) {
    (
        StateLabel::new("Config"),
        Box::new(Config::default()),
        vec![],
    )
}
