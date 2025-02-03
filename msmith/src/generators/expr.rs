use crate::{
    generators::NumberGenerator,
    move_ast::{Expression, MoveAST, NumberLiteral},
    states::{Primitive, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};
use log::warn;
use num_bigint::BigUint;

#[derive(Default)]
pub struct ExpressionGenerator;

impl Labelled for ExpressionGenerator {
    fn label() -> Label {
        GenLabel::new_func_body_level("ExpressionGenerator").into()
    }
}

impl Register<GeneratorEntry> for ExpressionGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
            forward: false,
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for ExpressionGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        warn!("check_constraint not implemented for ExpressionGenerator");
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        warn!("subtrees not implemented for ExpressionGenerator");
        let mut subtrees = vec![];

        subtrees.push(Subtree::new_generator_subtree(
            NumberGenerator::label().try_into().unwrap(),
            AnyConstraint::new(),
        ));

        let idx = u.choose_index(subtrees.len()).unwrap();
        let selected = vec![subtrees.remove(idx)];
        Ok((selected, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let node = asts.into_iter().next().unwrap();
        if let Ok(number) = node.into_numberliteral() {
            return Ok(Expression::NumberLiteral(number).into());
        }
        unimplemented!()
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression().is_some()
    }
}
