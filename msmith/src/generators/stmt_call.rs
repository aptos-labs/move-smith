use crate::{
    generators::{FuncCallGenerator, StatementGenerator},
    move_ast::{Expression, MoveAST, Statement},
    states::get_current_info,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct CallStmtGenerator;

impl LabelledGenerator for CallStmtGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("CallStmtGenerator")
    }
}

impl Register<GeneratorEntry> for CallStmtGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for CallStmtGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        get_current_info(env).func_call_nesting_depth <= 4
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        Ok((
            vec![Subtree::new_generator_subtree(
                FuncCallGenerator::label(),
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
        let call = asts
            .into_iter()
            .next()
            .unwrap()
            .into_functioncall()
            .unwrap();

        Ok(MoveAST::Statement(Statement::Expression(
            Expression::FunctionCall(call),
        )))
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
