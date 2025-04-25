use crate::{
    generators::{CallArgumentsGenerator, CallableGenerator},
    move_ast::{FunctionCall, MoveAST},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct FuncCallGenerator;

impl LabelledGenerator for FuncCallGenerator {
    fn label() -> GenLabel {
        GenLabel::new("FuncCallGenerator")
    }
}

impl Register<GeneratorEntry> for FuncCallGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for FuncCallGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let mut subtrees = vec![];
        subtrees.push(Subtree::new_generator_subtree(
            CallableGenerator::label(),
            AnyConstraint::new(),
        ));
        subtrees.push(Subtree::new_generator_subtree(
            CallArgumentsGenerator::label(),
            AnyConstraint::new(),
        ));
        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let mut iter = asts.into_iter();
        let callable = iter.next().unwrap().into_callable().unwrap();
        let args = iter.next().unwrap().into_callarguments().unwrap();
        Ok(FunctionCall { callable, args }.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_functioncall().is_some()
    }
}
