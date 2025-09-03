use crate::{
    generators::{ExprOfTypeGenerator, IfElseGenerator},
    move_ast::{Expression, MoveAST},
    states::almost_reached_max_expr_depth,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTIfElseGenerator;

impl LabelledGenerator for EOTIfElseGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTIfElseGenerator")
    }
}

impl Register<GeneratorEntry> for EOTIfElseGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTIfElseGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        !almost_reached_max_expr_depth(env, 1)
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        Ok((
            vec![Subtree::new_generator_subtree(
                IfElseGenerator::label(),
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
        let ite = asts.into_iter().next().unwrap().into_ifelse().unwrap();
        Ok(Expression::IfElse(ite).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression()
            .map(|e| e.as_ifelse().is_some())
            .unwrap_or(false)
    }
}
