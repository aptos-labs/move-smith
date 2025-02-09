use crate::{
    ids::{Id, IdKind},
    move_ast::{MoveAST, StructField},
    types::{NumberType, Primitive, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct StructFieldGenerator;

impl LabelledGenerator for StructFieldGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("StructFieldGenerator")
    }
}

impl Register<GeneratorEntry> for StructFieldGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for StructFieldGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        // constraint.check::<bool>("can_be_struct") && constraint.check::<bool>("can_be_type_param")
        true
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        warn!("StructFieldGenerator::subtrees not implemented");
        Ok((vec![], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        _asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        warn!("StructFieldGenerator::compose not implemented");
        Ok(StructField {
            name: Id::new_str("placeholder", IdKind::Var),
            ty: Type::Primitive(Primitive::Number(NumberType::U64)),
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        _ast: &MoveAST,
    ) -> bool {
        warn!("StructFieldGenerator::check_ast not implemented");
        true
    }
}
