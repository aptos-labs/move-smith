use crate::{
    generators::{InlineSpecGenerator, StatementGenerator},
    move_ast::{MoveAST, Statement},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct StmtSpecGenerator;

impl LabelledGenerator for StmtSpecGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("StmtSpecGenerator")
    }
}

impl Register<GeneratorEntry> for StmtSpecGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for StmtSpecGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        Ok((
            vec![Subtree::new_generator_subtree(
                InlineSpecGenerator::label(),
                AnyConstraint::new(),
            )],
            AnyConstraint::new(),
        ))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let spec_block = asts.into_iter().next().unwrap().into_specblock().unwrap();
        Ok(MoveAST::Statement(Statement::Spec(spec_block)))
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        if let Some(Statement::Spec(_)) = ast.as_statement() {
            true
        } else {
            false
        }
    }
}
