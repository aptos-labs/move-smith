use super::ExpressionGenerator;
use crate::{
    generators::StatementGenerator,
    move_ast::{MoveAST, Statement},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct ExprStmtGenerator;

impl Labelled for ExprStmtGenerator {
    fn label() -> Label {
        GenLabel::new_func_body_level("ExprStmtGenerator").into()
    }
}

impl Register<GeneratorEntry> for ExprStmtGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![StatementGenerator::label().try_into().unwrap()],
            forward: false,
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for ExprStmtGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        warn!("check_constraint not implemented for ExprStmtGenerator");
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
                ExpressionGenerator::label().try_into().unwrap(),
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
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_statement().is_some()
    }
}
