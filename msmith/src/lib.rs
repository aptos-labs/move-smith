use anyhow::Result;
use arbitrary::Unstructured;
use framework::{AnyConstraint, Framework, FrameworkBuilder, LabelledGenerator};
use log::debug;

pub mod cli;
pub mod codegen;
pub mod execution;
pub mod generators;
pub mod move_ast;
pub mod special;
pub mod states;
pub mod utils;

use codegen::CodeGenerator;
use generators::*;
use move_ast::MoveAST;
use states::*;

pub struct MoveSmith {
    framework: Framework<MoveAST, AnyConstraint>,
}

pub enum Variant {
    Default,
    FlushWrites,
}

impl MoveSmith {
    pub fn new() -> Self {
        Self::variant(Variant::Default)
    }

    pub fn from_framework(framework: Framework<MoveAST, AnyConstraint>) -> Self {
        MoveSmith { framework }
    }

    pub fn variant(variant: Variant) -> Self {
        let builder = FrameworkBuilder::new()
            .add_generator::<ProgramGenerator>()
            .add_generator::<ModuleGenerator>()
            .add_generator::<StructGenerator>()
            .add_generator::<StructFieldGenerator>()
            .add_generator::<FunctionGenerator>()
            .add_generator::<SignatureGenerator>()
            .add_generator::<BlockGenerator>()
            .add_generator::<SequenceGenerator>()
            .add_generator::<StatementGenerator>()
            .add_generator::<LetGenerator>()
            .add_generator::<ExpressionGenerator>()
            .add_generator::<ExprStmtGenerator>()
            .add_generator::<NumberGenerator>()
            .add_generator::<TupleGenerator>()
            .add_state::<config::GenerationConfig>()
            .add_state::<TypePool>()
            .add_state::<IdPool>()
            .add_state::<CurrScope>()
            .add_state::<PartialInfo>();

        use Variant as V;
        let framework = match variant {
            V::Default => builder,
            V::FlushWrites => builder
                .add_generator::<special::flush_writes::ConsumerSignatureGenerator>()
                .add_generator::<special::flush_writes::TupleSignatureGenerator>(),
        }
        .build();
        Self::from_framework(framework)
    }

    pub fn generate(&self, data: &[u8]) -> Result<String> {
        let u = &mut Unstructured::new(data);
        let prog = self
            .framework
            .generate(u, &ProgramGenerator::label(), &AnyConstraint::new())?;
        debug!("The generated program:");
        debug!("{:#?}", prog);
        Ok(prog.emit_code())
    }
}
