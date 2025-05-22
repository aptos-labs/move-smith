use crate::{
    generators::{ProgramGenerator, ScriptGenerator},
    move_ast::MoveAST,
};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};

#[derive(Debug, Default)]
pub struct PerTestInfo {
    pub generating_script: bool,
}

impl PerTestInfo {
    pub fn reset(&mut self) {
        self.generating_script = false;
    }
}

impl LabelledState for PerTestInfo {
    fn label() -> StateLabel {
        StateLabel::new("PerTestInfo")
    }
}

impl Register<StateEntry> for PerTestInfo {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![ScriptGenerator::label(), ProgramGenerator::label()],
        }
    }
}

impl State<MoveAST> for PerTestInfo {
    fn update_pre(&mut self, _u: &mut Unstructured, generator: &GenLabel) {
        if generator == &ScriptGenerator::label() {
            self.generating_script = true;
        }
    }

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, generator: &GenLabel) {
        if generator == &ScriptGenerator::label() {
            self.reset();
        }

        if generator == &ScriptGenerator::label() {
            self.generating_script = false;
        }
    }
}
