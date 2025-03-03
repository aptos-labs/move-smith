use super::TupleGenerator;
use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Expression, MoveAST},
    states::{GenericType, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTTupleGenerator;

impl LabelledGenerator for EOTTupleGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTTupleGenerator")
    }
}

impl Register<GeneratorEntry> for EOTTupleGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTTupleGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        let typ = constraint.get::<Type>("type").unwrap();
        match typ {
            Type::Generic(GenericType::Tuple(_)) => true,
            _ => false,
        }
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        if let Some(Type::Generic(GenericType::Tuple(tuple_type))) = constraint.get::<Type>("type")
        {
            let gen_constraint = constraint.clone().with("type", tuple_type.clone());
            let subtree = Subtree::new_generator_subtree(TupleGenerator::label(), gen_constraint);
            Ok((vec![subtree], AnyConstraint::new()))
        } else {
            panic!("EOTTupleGenerator::subtrees: constraint does not have a tuple type");
        }
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let tuple = asts.into_iter().next().unwrap().into_tuple().unwrap();
        Ok(Expression::Tuple(tuple).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast.as_expression() {
            Some(Expression::Tuple(_)) => true,
            _ => false,
        }
    }
}
