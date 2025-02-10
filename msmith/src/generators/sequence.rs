use crate::{
    move_ast::{MoveAST, Sequence},
    states::get_config,
    StatementGenerator,
};
use anyhow::{Ok, Result};
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct SequenceGenerator;

impl LabelledGenerator for SequenceGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("SequenceGenerator")
    }
}

impl Register<GeneratorEntry> for SequenceGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for SequenceGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let num_statements = get_config(env).num_stmts_in_sequence.select(u)?;

        let mut subtrees = vec![];
        for _ in 0..num_statements {
            subtrees.push(Subtree::new_generator_subtree(
                StatementGenerator::label(),
                AnyConstraint::new(),
            ));
        }
        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let statements = asts
            .into_iter()
            .map(|ast| ast.try_into().unwrap())
            .collect();
        Ok(Sequence { statements }.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_sequence().is_some()
    }
}
