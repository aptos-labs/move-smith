use crate::{
    move_ast::{MoveAST, NumberLiteral},
    states::{NumberType, Primitive, Type, TypePool},
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};
use num_bigint::BigUint;

#[derive(Default)]
pub struct NumberGenerator;

impl Labelled for NumberGenerator {
    fn label() -> Label {
        GenLabel::new("NumberGenerator").into()
    }
}

impl Register<GeneratorEntry> for NumberGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for NumberGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<NumberType>("type")
            && constraint.check_not_exist_or_has_type::<BigUint>("min")
            && constraint.check_not_exist_or_has_type::<BigUint>("max")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let type_pool = env.get::<TypePool>().unwrap();
        let num_typ = match constraint.get::<NumberType>("type") {
            Some(typ) => typ.clone(),
            None => type_pool.random_number_type(u)?,
        };

        let mut value = match &num_typ {
            NumberType::U8 => BigUint::from(u8::arbitrary(u)?),
            NumberType::U16 => BigUint::from(u16::arbitrary(u)?),
            NumberType::U32 => BigUint::from(u32::arbitrary(u)?),
            NumberType::U64 => BigUint::from(u64::arbitrary(u)?),
            NumberType::U128 => BigUint::from(u128::arbitrary(u)?),
            NumberType::U256 => BigUint::from_bytes_be(u.bytes(32)?),
        };

        // Note: We are not uniformly sampling from the range [min, max].
        // Instead, all out-of-range values are clamped to the bounds.
        if let Some(min) = constraint.get::<BigUint>("min") {
            value = value.max(min.clone());
        }

        if let Some(max) = constraint.get::<BigUint>("max") {
            value = value.min(max.clone());
        }

        let typ = Type::Primitive(Primitive::Number(num_typ));

        Ok((
            vec![Subtree::new_single_candidate(MoveAST::NumberLiteral(
                NumberLiteral { value, typ },
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
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_numberliteral().is_some()
    }
}
