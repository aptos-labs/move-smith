use super::ExpressionGenerator;
use crate::{
    move_ast::{MoveAST, Tuple},
    states::{GenericType, TupleType, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct TupleGenerator;

impl Labelled for TupleGenerator {
    fn label() -> Label {
        GenLabel::new("TupleGenerator").into()
    }
}

impl Register<GeneratorEntry> for TupleGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for TupleGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<TupleType>("type")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let tuple_type = constraint.get::<TupleType>("type").unwrap();
        let mut subtrees = vec![];
        for elem_typ in &tuple_type.types {
            let mut expr_constraint = AnyConstraint::new();
            expr_constraint.insert("type", elem_typ.clone());
            subtrees.push(Subtree::new_generator_subtree(
                ExpressionGenerator::label().try_into().unwrap(),
                expr_constraint,
            ));
        }
        Ok((subtrees, constraint.clone()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let expressions = asts
            .into_iter()
            .map(|ast| ast.into_expression().unwrap())
            .collect();
        Ok(Tuple { expressions }.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_tuple().is_some()
    }
}
