use crate::{
    move_ast::{MoveAST, Pattern},
    states::{get_curr_scope, get_partial_patterns, get_patterns_for_type, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::error;

#[derive(Default)]
pub struct PatternGenerator;

impl LabelledGenerator for PatternGenerator {
    fn label() -> GenLabel {
        GenLabel::new("PatternGenerator")
    }
}

impl Register<GeneratorEntry> for PatternGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for PatternGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<Type>("type")
            && constraint.check_not_exist_or_has_type::<bool>("no_partial")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let Some(typ) = constraint.get::<Type>("type") else {
            panic!("Type not found in constraint")
        };
        let curr_scope = get_curr_scope(env);
        let mut patterns = get_patterns_for_type(u, env, typ, &curr_scope);

        let no_partial_pattern = constraint.get_or("no_partial", false);

        if !no_partial_pattern {
            let partials = patterns
                .iter()
                .filter_map(|pat| get_partial_patterns(u, pat))
                .collect::<Vec<Pattern>>();
            patterns.extend(partials);
        }

        let pattern_nodes = patterns
            .into_iter()
            .map(|p| p.into())
            .collect::<Vec<MoveAST>>();

        if pattern_nodes.is_empty() {
            error!("No patterns found for type {typ:?}");
        }
        let subtree = Subtree::new_candidates_subtree(pattern_nodes);
        Ok((vec![subtree], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        Ok(asts.into_iter().next().unwrap())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_pattern().is_some()
    }
}
