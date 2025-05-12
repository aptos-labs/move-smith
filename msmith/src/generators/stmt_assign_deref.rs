use crate::{
    generators::{AssignDerefGenerator, StatementGenerator},
    move_ast::{Expression, MoveAST, Statement},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct StmtAssignDerefGenerator;

impl LabelledGenerator for StmtAssignDerefGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("StmtAssignDerefGenerator")
    }
}

impl Register<GeneratorEntry> for StmtAssignDerefGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for StmtAssignDerefGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let subtree =
            Subtree::new_generator_subtree(AssignDerefGenerator::label(), AnyConstraint::new());
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
        Ok(Statement::Expression(Expression::Assignment(assign)).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        matches!(ast, MoveAST::Statement(Statement::LetAssign(_)))
    }
}
