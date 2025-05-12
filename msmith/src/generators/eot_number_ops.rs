use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{BinOp, BinOperator, Expression, MoveAST, NumberLiteral},
    states::{reached_max_expr_depth, NumberType, Primitive, Type},
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use num_bigint::BigUint;

const OPS: [BinOperator; 10] = [
    BinOperator::Add,
    BinOperator::Sub,
    BinOperator::Mul,
    BinOperator::Div,
    BinOperator::Mod,
    BinOperator::Shl,
    BinOperator::Shr,
    BinOperator::BitAnd,
    BinOperator::BitOr,
    BinOperator::BitXor,
];

#[derive(Default)]
pub struct EOTNumberOpsGenerator;

impl LabelledGenerator for EOTNumberOpsGenerator {
    fn label() -> GenLabel {
        GenLabel::new("TypedEOTNumberOpsGenerator")
    }
}

impl Register<GeneratorEntry> for EOTNumberOpsGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTNumberOpsGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        matches!(
            constraint.get::<Type>("type").unwrap(),
            Type::Primitive(Primitive::Number(_))
        ) && !reached_max_expr_depth(env)
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let num_typ = match constraint.get::<Type>("type") {
            Some(Type::Primitive(Primitive::Number(num_type))) => num_type.clone(),
            _ => panic!("EOTNumberOpsGenerator::subtrees: constraint does not have a number type"),
        };
        let op = u.choose(&OPS)?.clone();
        let comp_constraint = constraint
            .clone()
            .with("num_type", num_typ.clone())
            .with("op", op.clone());

        // First number can be arbitray expression of the desired type
        let mut subtrees = vec![Subtree::new_generator_subtree(
            ExprOfTypeGenerator::label(),
            constraint.clone(),
        )];

        // For most cases, we want to generate RHS smartly to avoid runtime abort.
        let smart_gen = u.ratio(99, 100)?;

        // Allow RHS to be arbitrary expression of the correct type
        if !smart_gen {
            match op {
                BinOperator::Shl | BinOperator::Shr => {
                    subtrees.push(Subtree::new_generator_subtree(
                        ExprOfTypeGenerator::label(),
                        AnyConstraint::new()
                            .with("type", Type::Primitive(Primitive::Number(NumberType::U8))),
                    ));
                },
                _ => {
                    subtrees.push(Subtree::new_generator_subtree(
                        ExprOfTypeGenerator::label(),
                        constraint.clone(),
                    ));
                },
            }
            return Ok((subtrees, comp_constraint));
        };

        // Smartly generate RHS
        match op {
            // Add and Sub can over/underflow
            // Thus for most cases, we generate a number literal of a smaller type
            BinOperator::Add | BinOperator::Sub => {
                let value = match &num_typ {
                    NumberType::U8 => BigUint::from(u.int_in_range(0..=127)? as u32),
                    NumberType::U16 => BigUint::from(u8::arbitrary(u)?),
                    NumberType::U32 => BigUint::from(u16::arbitrary(u)?),
                    NumberType::U64 => BigUint::from(u32::arbitrary(u)?),
                    NumberType::U128 => BigUint::from(u64::arbitrary(u)?),
                    NumberType::U256 => BigUint::from(u128::arbitrary(u)?),
                };
                let rhs = NumberLiteral {
                    value,
                    typ: Type::Primitive(Primitive::Number(num_typ.clone())),
                };
                subtrees.push(Subtree::new_single_candidate(
                    Expression::NumberLiteral(rhs).into(),
                ));
            },
            // Mul can overflow much more easily than add
            // Thus we stricly generate a small number literal for RHS
            BinOperator::Mul => {
                let upper = match &num_typ {
                    NumberType::U8 => 4,
                    NumberType::U16 => (u8::MAX / 4) as u32,
                    NumberType::U32 => (u16::MAX / 4) as u32,
                    NumberType::U64 => (u32::MAX / 4) as u32,
                    NumberType::U128 => (u64::MAX / 4) as u32,
                    NumberType::U256 => (u128::MAX / 4) as u32,
                };
                let rhs = NumberLiteral {
                    value: BigUint::from(u.int_in_range(0..=upper)? as u32),
                    typ: Type::Primitive(Primitive::Number(num_typ.clone())),
                };
                subtrees.push(Subtree::new_single_candidate(
                    Expression::NumberLiteral(rhs).into(),
                ));
            },
            // Only need to make sure RHS is not zero
            BinOperator::Div | BinOperator::Mod => {
                let mut value = match &num_typ {
                    NumberType::U8 => BigUint::from(u8::arbitrary(u)?),
                    NumberType::U16 => BigUint::from(u16::arbitrary(u)?),
                    NumberType::U32 => BigUint::from(u32::arbitrary(u)?),
                    NumberType::U64 => BigUint::from(u64::arbitrary(u)?),
                    NumberType::U128 => BigUint::from(u128::arbitrary(u)?),
                    NumberType::U256 => BigUint::from_bytes_be(u.bytes(32)?),
                };
                value = value.max(BigUint::from(1u8));
                let rhs = NumberLiteral {
                    value,
                    typ: Type::Primitive(Primitive::Number(num_typ.clone())),
                };
                subtrees.push(Subtree::new_single_candidate(
                    Expression::NumberLiteral(rhs).into(),
                ));
            },
            // Need to make sure RHS doesn't exceed the bit width of LHS type
            BinOperator::Shl | BinOperator::Shr => {
                let num_bits = match num_typ {
                    NumberType::U8 => 8,
                    NumberType::U16 => 16,
                    NumberType::U32 => 32,
                    NumberType::U64 => 64,
                    NumberType::U128 => 128,
                    NumberType::U256 => 256,
                };
                let num_shift = u.int_in_range(0..=num_bits - 1)? as u32;
                let rhs = NumberLiteral {
                    value: BigUint::from(num_shift),
                    typ: Type::Primitive(Primitive::Number(NumberType::U8)),
                };
                subtrees.push(Subtree::new_single_candidate(
                    Expression::NumberLiteral(rhs).into(),
                ));
            },
            // No constraint on RHS
            BinOperator::BitAnd | BinOperator::BitOr | BinOperator::BitXor => {
                subtrees.push(Subtree::new_generator_subtree(
                    ExprOfTypeGenerator::label(),
                    constraint.clone(),
                ));
            },
            _ => panic!("EOTNumberOpsGenerator::subtrees: unsupported operator {op:?}"),
        };
        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let op = constraint.get::<BinOperator>("op").unwrap();
        let num_type = constraint.get::<NumberType>("num_type").unwrap();
        let mut iter = asts.into_iter();
        let left = iter.next().unwrap().into_expression().unwrap();
        let right = iter.next().unwrap().into_expression().unwrap();
        Ok(Expression::BinOp(BinOp {
            op: op.clone(),
            typ: Primitive::Number(num_type.clone()),
            left: Box::new(left),
            right: Box::new(right),
        })
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression().and_then(|e| e.as_binop()).is_some()
    }
}
