use crate::{
    generators::{ExprOfTypeGenerator, NumberGenerator},
    move_ast::{Expression, MoveAST},
    states::{Primitive, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use num_bigint::BigUint;

#[derive(Default)]
pub struct EOTNumberGenerator;

impl LabelledGenerator for EOTNumberGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTNumberGenerator").into()
    }
}

impl Register<GeneratorEntry> for EOTNumberGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTNumberGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        let is_num_type = match constraint.get::<Type>("type").unwrap() {
            Type::Primitive(Primitive::Number(_)) => true,
            _ => false,
        };
        is_num_type
            && constraint.check_not_exist_or_has_type::<BigUint>("min")
            && constraint.check_not_exist_or_has_type::<BigUint>("max")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        if let Type::Primitive(Primitive::Number(num_type)) =
            constraint.get::<Type>("type").unwrap()
        {
            let gen_constraint = constraint.clone().with("type", num_type.clone());
            let subtree = Subtree::new_generator_subtree(NumberGenerator::label(), gen_constraint);
            Ok((vec![subtree], AnyConstraint::new()))
        } else {
            panic!("EOTNumberGenerator::subtrees: constraint does not have a number type");
        }
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let num_literal = asts
            .into_iter()
            .next()
            .unwrap()
            .into_numberliteral()
            .unwrap();
        Ok(Expression::NumberLiteral(num_literal).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast.as_expression() {
            Some(Expression::NumberLiteral(_)) => true,
            _ => false,
        }
    }
}
