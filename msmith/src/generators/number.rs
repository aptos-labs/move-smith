use crate::{
    move_ast::{MoveAST, NumberLiteral},
    states::{
        get_config, random_type_from_curr_scope, NumberType, Primitive, Type, TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use core::cmp::min;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use num_bigint::BigUint;
use num_traits::Zero;

/// ---- SplitMix64 (tiny, fast; fine for fuzzing, NOT crypto) ----
#[inline]
fn splitmix64_next(state: &mut u64) -> u64 {
    *state = state.wrapping_add(0x9E37_79B9_7F4A_7C15);
    let mut z = *state;
    z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
    z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
    z ^ (z >> 31)
}

#[inline]
fn seed_from_unstructured(u: &mut Unstructured) -> arbitrary::Result<u64> {
    // Consume ≤ 8 bytes (whatever is left), zero-extend if fewer.
    let n = min(8, u.len()); // remaining bytes available
    let slice = u.bytes(n)?; // consumes n bytes; n may be 0
    let mut buf = [0u8; 8];
    buf[..n].copy_from_slice(slice);
    Ok(u64::from_le_bytes(buf))
}

#[inline]
fn fill_bytes_splitmix(out: &mut [u8], mut state: u64) {
    for chunk in out.chunks_mut(8) {
        let x = splitmix64_next(&mut state).to_le_bytes();
        let m = min(8, chunk.len());
        chunk[..m].copy_from_slice(&x[..m]);
    }
}

/// Make exactly `bit_size` random bits as a BigUint using only up to 8 bytes from `u`.
pub fn biguint_from_unstructured(
    u: &mut Unstructured,
    bit_size: usize,
) -> arbitrary::Result<BigUint> {
    if bit_size == 0 {
        return Ok(BigUint::zero());
    }

    let nbytes = (bit_size + 7) / 8;
    let mut bytes = vec![0u8; nbytes];

    // Expand from ≤8 consumed bytes
    let seed = seed_from_unstructured(u)?;
    fill_bytes_splitmix(&mut bytes, seed);

    // Mask excess high bits so we return exactly `bit_size` bits
    let excess = nbytes * 8 - bit_size;
    if excess > 0 {
        let mask = 0xFFu8 >> excess;
        *bytes.last_mut().unwrap() &= mask;
    }

    Ok(BigUint::from_bytes_le(&bytes))
}

#[derive(Default)]
pub struct NumberGenerator;

impl LabelledGenerator for NumberGenerator {
    fn label() -> GenLabel {
        GenLabel::new("TypedNumberGenerator")
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
        let num_typ = match constraint.get::<NumberType>("type") {
            Some(typ) => typ.clone(),
            None => {
                let selector = TypeSelectorBuilder::all_no(get_config(env))
                    .number(1)
                    .build();
                let random_typ = random_type_from_curr_scope(u, env, vec![selector])?;
                match random_typ {
                    Type::Primitive(Primitive::Number(typ)) => typ,
                    _ => panic!("NumberGenerator::subtrees: random type is not a number"),
                }
            },
        };

        let mut value = match &num_typ {
            NumberType::U8 => BigUint::from(u8::arbitrary(u)?),
            NumberType::U16 => BigUint::from(u16::arbitrary(u)?),
            NumberType::U32 => BigUint::from(u32::arbitrary(u)?),
            NumberType::U64 => BigUint::from(u64::arbitrary(u)?),
            NumberType::U128 => biguint_from_unstructured(u, 128)?,
            NumberType::U256 => biguint_from_unstructured(u, 256)?,
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
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_numberliteral().is_some()
    }
}
