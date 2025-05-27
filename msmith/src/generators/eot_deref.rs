use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Dereference, Expression, MoveAST},
    states::{
        almost_reached_max_expr_depth, get_current_info,
        types::{GenericType, ReferenceType, Type},
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTDereferenceGenerator;

impl LabelledGenerator for EOTDereferenceGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTDereferenceGenerator")
    }
}

impl Register<GeneratorEntry> for EOTDereferenceGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTDereferenceGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        !almost_reached_max_expr_depth(env, 1) && {
            let inner_type = constraint.get::<Type>("type").unwrap();
            !inner_type.is_reference() && !inner_type.is_function() && !inner_type.is_tuple()
        }
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let inner_type = constraint.get::<Type>("type").unwrap().clone();

        let mutable = if get_current_info(env).is_in_lambda() {
            false
        } else {
            bool::arbitrary(u)?
        };

        let ref_type = match mutable {
            true => Type::Generic(GenericType::Reference(ReferenceType::Mutable(Box::new(
                inner_type,
            )))),
            false => Type::Generic(GenericType::Reference(ReferenceType::Immutable(Box::new(
                inner_type,
            )))),
        };
        let subtrees = vec![Subtree::new_generator_subtree(
            ExprOfTypeGenerator::label(),
            AnyConstraint::new().with("type", ref_type),
        )];
        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let ref_expr = asts.into_iter().next().unwrap().into_expression().unwrap();
        let deref = Dereference(Box::new(ref_expr));
        Ok(Expression::Dereference(deref).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression()
            .and_then(|e| e.as_dereference())
            .is_some()
    }
}
