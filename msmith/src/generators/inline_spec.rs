use crate::{
    generators::SpecBlockGenerator,
    move_ast::{MoveAST, SpecContext},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct InlineSpecGenerator;

impl LabelledGenerator for InlineSpecGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("InlineSpecGenerator")
    }
}

impl Register<GeneratorEntry> for InlineSpecGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for InlineSpecGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let context = SpecContext::InlineSpec;
        let constraint = AnyConstraint::new().with("context", context);

        let subtrees = vec![Subtree::new_generator_subtree(
            SpecBlockGenerator::label(),
            constraint,
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
            matches!(spec_block.context, SpecContext::InlineSpec)
        } else {
            false
        }
    }
}
