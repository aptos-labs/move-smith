use crate::{
    generators::{NumberGenerator, TupleGenerator},
    move_ast::{Expression, MoveAST},
    states::{get_config, get_type_pool, GenericType, Primitive, Type, TypeSelectorBuilder},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct ExpressionGenerator;

impl LabelledGenerator for ExpressionGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("ExpressionGenerator")
    }
}

impl Register<GeneratorEntry> for ExpressionGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for ExpressionGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<Type>("type")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let selector = TypeSelectorBuilder::all_no(get_config(env))
            .number(1)
            .build();
        let random_type = get_type_pool(env).random_type(u, vec![selector])?;
        let required_type = constraint.get_or::<Type>("type", random_type);

        let mut expr_constraint = AnyConstraint::new();
        let subtree = match required_type {
            Type::Primitive(Primitive::Number(n)) => {
                expr_constraint.insert("type", n.clone());
                Subtree::new_generator_subtree(NumberGenerator::label(), expr_constraint)
            },
            Type::Generic(GenericType::Tuple(t)) => {
                expr_constraint.insert("type", t.clone());
                Subtree::new_generator_subtree(TupleGenerator::label(), expr_constraint)
            },
            _ => unimplemented!(),
        };
        Ok((vec![subtree], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        use MoveAST as M;
        let node = asts.into_iter().next().unwrap();
        Ok(match node {
            M::NumberLiteral(n) => Expression::NumberLiteral(n).into(),
            M::Tuple(t) => Expression::Tuple(t).into(),
            _ => unimplemented!(),
        })
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression().is_some()
    }
}
