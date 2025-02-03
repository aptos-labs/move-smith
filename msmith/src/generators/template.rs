use crate::move_ast::MoveAST;
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct TemplateGenerator;

impl Labelled for TemplateGenerator {
    fn label() -> Label {
        GenLabel::new("TemplateGenerator").into()
    }
}

impl Register<GeneratorEntry> for TemplateGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
            forward: false,
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for TemplateGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        unimplemented!()
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        unimplemented!()
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        _asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        unimplemented!()
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        _ast: &MoveAST,
    ) -> bool {
        unimplemented!()
    }
}
