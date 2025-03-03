use super::AssignmentGenerator;
use crate::{
    generators::StatementGenerator,
    move_ast::{Expression, MoveAST, Statement},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct LetGenerator;

impl LabelledGenerator for LetGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("LetGenerator")
    }
}

impl Register<GeneratorEntry> for LetGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for LetGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        warn!("check_constraint not implemented for LetGenerator");
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        // TODO: add declaration only
        let subtree =
            Subtree::new_generator_subtree(AssignmentGenerator::label(), AnyConstraint::new());
        Ok((vec![subtree], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let assign = asts.into_iter().next().unwrap().into_assignment().unwrap();
        Ok(Statement::Let(Expression::Assignment(assign)).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast {
            MoveAST::Statement(Statement::Let(expr)) => {
                matches!(expr, Expression::Variable(_) | Expression::Assignment(_))
            },
            _ => false,
        }
    }
}
