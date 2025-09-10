use crate::{
    generators::{EnumMatchGenerator, ExprOfTypeGenerator},
    move_ast::{Expression, MoveAST},
    states::{
        almost_reached_max_expr_depth, get_config, get_current_info, get_per_module_info,
        is_in_spec, random_type_from_curr_scope, TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTMatchGenerator;

impl LabelledGenerator for EOTMatchGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTMatchGenerator")
    }
}

impl Register<GeneratorEntry> for EOTMatchGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTMatchGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        get_per_module_info(env).has_enum
            && !almost_reached_max_expr_depth(env, 2)
            && get_current_info(env).match_nesting_depth <= 3
            && !is_in_spec(env)
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let selector = TypeSelectorBuilder::all_no(get_config(env))
            .enums(1)
            .build();
        let enum_type = random_type_from_curr_scope(u, env, vec![selector])?;
        let subtrees = vec![Subtree::new_generator_subtree(
            EnumMatchGenerator::label(),
            constraint.clone().with("enum", enum_type.clone()),
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
        let m = asts.into_iter().next().unwrap().into_enummatch().unwrap();
        Ok(Expression::EnumMatch(m).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression()
            .map(|e| e.as_enummatch().is_some())
            .unwrap_or(false)
    }
}
