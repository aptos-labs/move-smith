use crate::{
    generators::SpecBlockGenerator,
    move_ast::{MoveAST, Signature, SpecContext},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct FunctionSpecGenerator;

impl LabelledGenerator for FunctionSpecGenerator {
    fn label() -> GenLabel {
        GenLabel::new_module_member_level("FunctionSpecGenerator")
    }
}

impl Register<GeneratorEntry> for FunctionSpecGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for FunctionSpecGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<Signature>("target_function")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let target_function: &Signature = constraint.get("target_function").unwrap();

        let context = SpecContext::FunctionSpec {
            target_function: target_function.clone(),
        };
        let block_constraint = AnyConstraint::new().with("context", context);

        let subtrees = vec![Subtree::new_generator_subtree(
            SpecBlockGenerator::label(),
            block_constraint,
        )];

        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        mut asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        Ok(asts.remove(0))
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        if let Some(spec_block) = ast.as_specblock() {
            matches!(spec_block.context, SpecContext::FunctionSpec { .. })
        } else {
            false
        }
    }
}
