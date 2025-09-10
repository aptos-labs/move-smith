use crate::{
    generators::{EnumGenerator, ModuleGenerator, SpecBlockGenerator, StructGenerator},
    move_ast::MoveAST,
};
use arbitrary::Unstructured;
use framework::{
    GenLabel, LabelledGenerator, LabelledState, Register, State, StateEntry, StateLabel,
};

#[derive(Debug, Default)]
pub struct PerModuleInfo {
    pub has_struct: bool,
    pub has_enum: bool,
    pub in_spec: bool,
}

impl PerModuleInfo {
    pub fn reset(&mut self) {
        self.has_struct = false;
        self.has_enum = false;
    }
}

impl LabelledState for PerModuleInfo {
    fn label() -> StateLabel {
        StateLabel::new("PerModuleInfo")
    }
}

impl Register<StateEntry> for PerModuleInfo {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![
                StructGenerator::label(),
                EnumGenerator::label(),
                ModuleGenerator::label(),
                SpecBlockGenerator::label(),
            ],
        }
    }
}

impl State<MoveAST> for PerModuleInfo {
    fn update_pre(&mut self, _u: &mut Unstructured, generator: &GenLabel) {
        if generator == &SpecBlockGenerator::label() {
            self.in_spec = true;
        }
    }

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, generator: &GenLabel) {
        if generator == &ModuleGenerator::label() {
            self.reset();
        }

        if generator == &StructGenerator::label() {
            self.has_struct = true;
        }

        if generator == &EnumGenerator::label() {
            self.has_enum = true;
        }

        if generator == &SpecBlockGenerator::label() {
            self.in_spec = false;
        }
    }
}
