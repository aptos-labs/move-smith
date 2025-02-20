use crate::{move_ast::MoveAST, states::Type};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct ExprOfTypeGenerator;

impl LabelledGenerator for ExprOfTypeGenerator {
    fn label() -> GenLabel {
        GenLabel::new("ExprOfTypeGenerator")
    }
}

impl Register<GeneratorEntry> for ExprOfTypeGenerator {
    fn register(&self) -> GeneratorEntry {
        let mut entry = GeneratorEntry::new::<Self>();
        entry.forward = true;
        entry
    }
}

impl Generator<MoveAST, AnyConstraint> for ExprOfTypeGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<Type>("type")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        unimplemented!()
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        _asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        unimplemented!()
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
