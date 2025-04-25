use super::ExprOfTypeGenerator;
use crate::{
    move_ast::{Expression, MoveAST, Unit},
    states::Type,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTUnitGenerator;

impl LabelledGenerator for EOTUnitGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTUnitGenerator")
    }
}

impl Register<GeneratorEntry> for EOTUnitGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTUnitGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        let typ = constraint.get::<Type>("type").unwrap();
        matches!(typ, Type::Unit)
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        Ok((
            vec![Subtree::new_single_candidate(MoveAST::Expression(
                Expression::Unit(Unit),
            ))],
            AnyConstraint::new(),
        ))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        Ok(asts.into_iter().next().unwrap())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        _ast: &MoveAST,
    ) -> bool {
        unimplemented!()
    }
}
