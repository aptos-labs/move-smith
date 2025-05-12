use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{BinOp, BinOperator, Bool, Expression, MoveAST, UnOp, UnOperator},
    states::{
        get_config, random_type_from_curr_scope, reached_max_expr_depth, Primitive, Type,
        TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::{Arbitrary, Unstructured};
use framework::{
    selection::choose_item_weighted, AnyConstraint, GenLabel, Generator, GeneratorEntry,
    LabelledGenerator, Register, StatePool, Subtree,
};

#[derive(Default)]
pub struct EOTBoolGenerator;

#[derive(Clone, Debug)]
enum EOTBoolKind {
    Literal,
    Not,
    NumericalOp,
    BooleanOp,
    ComparisonOp,
}

impl EOTBoolKind {
    fn weights() -> Vec<(Self, u32)> {
        vec![
            (EOTBoolKind::Literal, 1),
            (EOTBoolKind::Not, 1),
            (EOTBoolKind::NumericalOp, 1),
            (EOTBoolKind::BooleanOp, 1),
            (EOTBoolKind::ComparisonOp, 3),
        ]
    }

    fn random_op(&self, u: &mut Unstructured) -> Option<BinOperator> {
        let mut candidates = vec![];
        match self {
            EOTBoolKind::Literal | EOTBoolKind::Not => return None,
            EOTBoolKind::BooleanOp => {
                candidates.push(BinOperator::And);
                candidates.push(BinOperator::Or);
            },
            EOTBoolKind::NumericalOp => {
                candidates.push(BinOperator::Lt);
                candidates.push(BinOperator::Leq);
                candidates.push(BinOperator::Gt);
                candidates.push(BinOperator::Geq);
            },
            EOTBoolKind::ComparisonOp => {
                candidates.push(BinOperator::Eq);
                candidates.push(BinOperator::Neq);
            },
        }
        Some(u.choose(&candidates).unwrap().clone())
    }
}

impl LabelledGenerator for EOTBoolGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTBoolGenerator")
    }
}

impl Register<GeneratorEntry> for EOTBoolGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTBoolGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        let typ = constraint.get::<Type>("type").unwrap();
        matches!(typ, Type::Primitive(Primitive::Bool))
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let mut subtrees = vec![];
        let kind = match reached_max_expr_depth(env) {
            true => EOTBoolKind::Literal,
            false => choose_item_weighted(u, &EOTBoolKind::weights())?,
        };
        let op = kind.random_op(u);
        let mut comp_constraint = AnyConstraint::new()
            .with("kind", kind.clone())
            .with("op", op);
        let bool_type = Type::Primitive(Primitive::Bool);

        match &kind {
            EOTBoolKind::Literal => {
                comp_constraint.insert("type", bool_type.clone());
                let value = bool::arbitrary(u).unwrap();
                let bool_expr = Expression::Bool(Bool { value });
                subtrees.push(Subtree::new_single_candidate(bool_expr.into()));
            },
            EOTBoolKind::Not => {
                comp_constraint.insert("type", bool_type.clone());
                let subtree = Subtree::new_generator_subtree(
                    ExprOfTypeGenerator::label(),
                    AnyConstraint::new().with("type", bool_type),
                );
                subtrees.push(subtree);
            },
            EOTBoolKind::BooleanOp => {
                comp_constraint.insert("type", bool_type.clone());
                for _ in 0..2 {
                    let subtree = Subtree::new_generator_subtree(
                        ExprOfTypeGenerator::label(),
                        AnyConstraint::new().with("type", bool_type.clone()),
                    );
                    subtrees.push(subtree);
                }
            },
            EOTBoolKind::NumericalOp => {
                let selector = TypeSelectorBuilder::all_no(get_config(env))
                    .number(1)
                    .build();
                let operand_type = random_type_from_curr_scope(u, env, vec![selector])?;
                comp_constraint.insert("type", operand_type.clone());
                for _ in 0..2 {
                    let subtree = Subtree::new_generator_subtree(
                        ExprOfTypeGenerator::label(),
                        AnyConstraint::new().with("type", operand_type.clone()),
                    );
                    subtrees.push(subtree);
                }
            },
            EOTBoolKind::ComparisonOp => {
                comp_constraint.insert("type", bool_type.clone());
                let selector = TypeSelectorBuilder::all_no(get_config(env))
                    .number(1)
                    .structs(1)
                    .enums(1)
                    .build();
                let operand_type = random_type_from_curr_scope(u, env, vec![selector])?;
                for _ in 0..2 {
                    let subtree = Subtree::new_generator_subtree(
                        ExprOfTypeGenerator::label(),
                        AnyConstraint::new().with("type", operand_type.clone()),
                    );
                    subtrees.push(subtree);
                }
            },
        }
        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let kind = constraint.get::<EOTBoolKind>("kind").unwrap();
        let op = constraint.get::<Option<BinOperator>>("op").unwrap().clone();
        let Some(Type::Primitive(typ)) = constraint.get::<Type>("type") else {
            panic!("EOTBoolGenerator::compose expected a primitive type");
        };

        match kind {
            EOTBoolKind::Literal => Ok(asts.into_iter().next().unwrap()),
            EOTBoolKind::Not => {
                let expr = asts.into_iter().next().unwrap().into_expression().unwrap();
                let unop_expr: Expression = UnOp {
                    op: UnOperator::Not,
                    expr: Box::new(expr),
                }
                .into();
                Ok(unop_expr.into())
            },
            &EOTBoolKind::NumericalOp | EOTBoolKind::BooleanOp | EOTBoolKind::ComparisonOp => {
                let Some(op) = op else {
                    panic!("EOTBoolGenerator::compose expected an operator");
                };
                let mut iter = asts.into_iter();
                let left = iter.next().unwrap().into_expression().unwrap();
                let right = iter.next().unwrap().into_expression().unwrap();
                let expr: Expression = BinOp {
                    op,
                    typ: typ.clone(),
                    left: Box::new(left),
                    right: Box::new(right),
                }
                .into();
                Ok(expr.into())
            },
        }
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression()
            .map(|e| e.as_binop().is_some() || e.as_unop().is_some())
            .unwrap_or(false)
    }
}
