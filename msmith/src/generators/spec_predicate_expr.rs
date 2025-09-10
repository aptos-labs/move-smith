use crate::{
    generators::ExpressionGenerator,
    move_ast::{MoveAST, SpecPredicate},
    states::{types::Primitive, Depth, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::trace;

// Sub-generator for expression-based predicates
#[derive(Default)]
pub struct SpecPredicateExpressionGenerator;

impl LabelledGenerator for SpecPredicateExpressionGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("SpecPredicateExpressionGenerator")
    }
}

impl Register<GeneratorEntry> for SpecPredicateExpressionGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for SpecPredicateExpressionGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        trace!("Generating expression predicate");

        // Limit expression depth to 1 for predicates
        env.get_mut::<Depth>().unwrap().expr_depth.set_max_depth(1);

        let expr_constraint = AnyConstraint::new().with("type", Type::Primitive(Primitive::Bool));

        let subtrees = vec![Subtree::new_generator_subtree(
            ExpressionGenerator::label(),
            expr_constraint,
        )];

        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        mut asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        env.get_mut::<Depth>().unwrap().expr_depth.reset_max_depth();
        let expr = asts.remove(0).try_into().unwrap();
        Ok(SpecPredicate::Expression(expr).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        matches!(ast.as_specpredicate(), Some(SpecPredicate::Expression(_)))
    }
}
