use crate::{
    generators::{ExprOfTypeGenerator, PatternGenerator},
    move_ast::{Assignment, MoveAST},
    states::{get_config, get_type_pool, Type, TypeSelectorBuilder},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct AssignmentGenerator;

impl LabelledGenerator for AssignmentGenerator {
    fn label() -> GenLabel {
        GenLabel::new("AssignmentGenerator")
    }
}

impl Register<GeneratorEntry> for AssignmentGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for AssignmentGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_not_exist_or_has_type::<Type>("type")
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let wanted_type = match constraint.get::<Type>("type") {
            Some(t) => t.clone(),
            None => {
                let type_selector = TypeSelectorBuilder::all_no(get_config(env))
                    .number(1)
                    .func_return(5)
                    .structs(1)
                    .enums(1)
                    .build();
                get_type_pool(env).random_type(u, vec![type_selector])?
            },
        };

        let gen_constraint = AnyConstraint::new().with("type", wanted_type.clone());
        let lhs = Subtree::new_generator_subtree(PatternGenerator::label(), gen_constraint.clone());
        let rhs =
            Subtree::new_generator_subtree(ExprOfTypeGenerator::label(), gen_constraint.clone());

        Ok((vec![lhs, rhs], gen_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let mut iter = asts.into_iter();
        let lhs = iter.next().unwrap().into_pattern().unwrap();
        let rhs = iter.next().unwrap().into_expression().unwrap();
        Ok(Assignment::AssignPattern(lhs, Box::new(rhs)).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_assignment().is_some()
    }
}
