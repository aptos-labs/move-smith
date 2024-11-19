use crate::ast::MoveAST;
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    label::{GenLabel, Label, Labelled},
    AnyConstraint, Generator, GeneratorEntry, Register, StatePool, Subtree,
};

#[derive(Default)]
pub struct ProgramGenerator;

impl Labelled for ProgramGenerator {
    fn label() -> Label {
        GenLabel::new_top_level("ProgramGenerator").into()
    }
}

impl Register<GeneratorEntry> for ProgramGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for ProgramGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Vec<Subtree<MoveAST, AnyConstraint>> {
        vec![Subtree::new_single_candidate(MoveAST::empty())]
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        mut asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        Ok(asts.remove(0))
    }

    fn check_ast(
        &self,
        env: &StatePool<MoveAST>,
        constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        true
    }
}
