use crate::{
    generators::SpecPredicateExpressionGenerator,
    move_ast::{MoveAST},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::trace;

// Top-level forwarding generator for spec predicates
#[derive(Default)]
pub struct SpecPredicateGenerator;

impl LabelledGenerator for SpecPredicateGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("SpecPredicateGenerator")
    }
}

impl Register<GeneratorEntry> for SpecPredicateGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for SpecPredicateGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        trace!("Generating spec predicate - forwarding to expression predicate");

        // For now, always forward to expression predicate
        // Later we can add random selection between different predicate types
        let subtrees = vec![Subtree::new_generator_subtree(
            SpecPredicateExpressionGenerator::label(),
            AnyConstraint::new(),
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
        // Just pass through the generated predicate
        Ok(asts.remove(0))
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_specpredicate().is_some()
    }
}