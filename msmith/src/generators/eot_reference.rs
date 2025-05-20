use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Expression, MoveAST, Reference},
    states::{GenericType, ReferenceType, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTReferenceGenerator;

impl LabelledGenerator for EOTReferenceGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTReferenceGenerator")
    }
}

impl Register<GeneratorEntry> for EOTReferenceGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTReferenceGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        matches!(
            constraint.get::<Type>("type").unwrap(),
            Type::Generic(GenericType::Reference(_))
        )
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let ref_type = match constraint.get::<Type>("type") {
            Some(Type::Generic(GenericType::Reference(ref_type))) => ref_type.clone(),
            _ => {
                panic!("EOTReferenceGenerator::subtrees: constraint does not have a reference type")
            },
        };
        let inner_type = ref_type.get_inner_type().clone();
        let subtrees = vec![Subtree::new_generator_subtree(
            ExprOfTypeGenerator::label(),
            constraint.clone().with("type", inner_type.clone()),
        )];
        Ok((subtrees, AnyConstraint::new().with("ref_type", ref_type)))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let inner_expr = asts.into_iter().next().unwrap().into_expression().unwrap();
        let ref_node = match constraint.get::<ReferenceType>("ref_type").unwrap() {
            ReferenceType::Immutable(_) => Reference::Immutable(Box::new(inner_expr)),
            ReferenceType::Mutable(_) => Reference::Mutable(Box::new(inner_expr)),
        };
        Ok(Expression::Reference(ref_node).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression().and_then(|e| e.as_reference()).is_some()
    }
}
