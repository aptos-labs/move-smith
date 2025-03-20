use crate::{generators::EnumMatchGenerator, move_ast::MoveAST};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};

#[derive(Debug, Default)]
pub struct CurrentInfo {
    pub match_nesting_depth: usize,
}

impl LabelledState for CurrentInfo {
    fn label() -> StateLabel {
        StateLabel::new("CurrentInfo")
    }
}

impl Register<StateEntry> for CurrentInfo {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![EnumMatchGenerator::label()],
        }
    }
}

impl State<MoveAST> for CurrentInfo {
    fn update_pre(&mut self, _u: &mut Unstructured, generator: &GenLabel) {
        if generator == &EnumMatchGenerator::label() {
            self.match_nesting_depth += 1;
        }
    }

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, generator: &GenLabel) {
        if generator == &EnumMatchGenerator::label() {
            self.match_nesting_depth -= 1;
        }
    }
}
