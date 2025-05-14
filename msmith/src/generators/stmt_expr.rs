use crate::{
    generators::{ExpressionGenerator, StatementGenerator},
    move_ast::{MoveAST, Statement},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct StmtExprGenerator;

impl LabelledGenerator for StmtExprGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("StmtExprGenerator")
    }
}

impl Register<GeneratorEntry> for StmtExprGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for StmtExprGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        Ok((
            vec![Subtree::new_generator_subtree(
                ExpressionGenerator::label(),
                constraint.clone(),
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
        let expr = asts.into_iter().next().unwrap().into_expression().unwrap();
        Ok(MoveAST::Statement(Statement::Expression(expr)))
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_statement().is_some()
    }
}
