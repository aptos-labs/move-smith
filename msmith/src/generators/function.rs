use crate::{
    move_ast::{Function, MoveAST},
    BlockGenerator, SignatureGenerator,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct FunctionGenerator;

impl Labelled for FunctionGenerator {
    fn label() -> Label {
        GenLabel::new_module_member_level("FunctionGenerator").into()
    }
}

impl Register<GeneratorEntry> for FunctionGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
            forward: false,
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for FunctionGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<bool>("has_return")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let mut subtrees = vec![];
        subtrees.push(Subtree::new_generator_subtree(
            SignatureGenerator::label().try_into().unwrap(),
            constraint.clone(),
        ));
        subtrees.push(Subtree::new_generator_subtree(
            BlockGenerator::label().try_into().unwrap(),
            constraint.clone(),
        ));
        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        mut asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let signature = asts.remove(0).into_signature().unwrap();
        let body = asts.remove(0).into_block().unwrap();
        Ok(Function { signature, body }.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_function().is_some()
    }
}
