use crate::ast::MoveAST;
use arbitrary::Unstructured;
use framework::{
    selection::RandomNumber, GenLabel, Label, Labelled, Register, State, StateEntry, StateLabel,
};

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

impl Labelled for Config {
    fn label() -> Label {
        StateLabel::new("Config").into()
    }
}

impl Register<StateEntry> for Config {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label().try_into().unwrap(),
            generators: vec![],
        }
    }
}

impl State<MoveAST> for Config {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {
        // Do nothing
    }

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, _generator: &GenLabel) {
        // Do nothing
    }
}
