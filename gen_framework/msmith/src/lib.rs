use arbitrary::Unstructured;
use framework::{AnyConstraint, Framework, FrameworkBuilder, Labelled};
use log::debug;

pub mod ast;
pub mod generators;
pub mod states;

use ast::{CodeGenerator, MoveAST};
use generators::*;
use states::*;

pub struct MoveSmith {
    framework: Framework<MoveAST, AnyConstraint>,
}

impl MoveSmith {
    pub fn new() -> Self {
        let framework = FrameworkBuilder::new()
            .add_generator::<ProgramGenerator>()
            .add_state::<Config>()
            .add_state::<TypePool>()
            .add_state::<IDPool>()
            .add_state::<CurrScope>()
            .build();
        MoveSmith { framework }
    }

    pub fn generate(&self, data: &[u8]) -> String {
        let u = &mut Unstructured::new(data);
        let prog = self
            .framework
            .generate(
                u,
                &ProgramGenerator::label().try_into().unwrap(),
                &AnyConstraint::new(),
            )
            .unwrap();
        debug!("The generated program:");
        debug!("{:#?}", prog);
        prog.emit_code()
    }
}
