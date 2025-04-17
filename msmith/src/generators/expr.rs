use super::ExprOfTypeGenerator;
use crate::{
    move_ast::MoveAST,
    states::{
        almost_reached_max_expr_depth, get_config, random_type_from_curr_scope, Type,
        TypeSelectorBuilder,
    },
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
        let mut gen_constraint = constraint.clone();

        if constraint.get::<Type>("type").is_none() {
            let selector = if almost_reached_max_expr_depth(env, 1) {
                // Select a simple type if we are almost at the max depth
                TypeSelectorBuilder::all_no(get_config(env))
                    .number(1)
                    .bool(1)
                    .build()
            } else {
                TypeSelectorBuilder::all_no(get_config(env))
                    .bool(1)
                    .number(1)
                    .structs(1)
                    .enums(1)
                    .tuple(1)
                    .func_return(10)
                    .build()
            };
            let random_type = random_type_from_curr_scope(u, env, vec![selector])?;
            gen_constraint.insert("type", random_type);
        }

        let subtree = Subtree::new_generator_subtree(ExprOfTypeGenerator::label(), gen_constraint);
        Ok((vec![subtree], AnyConstraint::new()))
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
        ast.as_expression().is_some()
    }
}
