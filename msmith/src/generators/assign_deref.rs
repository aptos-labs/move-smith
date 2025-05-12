use crate::{
    generators::{ExprOfTypeGenerator},
    move_ast::{Assignment, Dereference, MoveAST},
    states::{
        get_config, random_type_from_curr_scope, types::ReferenceType, Type, TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct AssignDerefGenerator;

impl LabelledGenerator for AssignDerefGenerator {
    fn label() -> GenLabel {
        GenLabel::new("AssignDerefGenerator")
    }
}

impl Register<GeneratorEntry> for AssignDerefGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for AssignDerefGenerator {
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
                    .bool(1)
                    .func_return(5)
                    .structs(1)
                    .enums(1)
                    .build();
                random_type_from_curr_scope(u, env, vec![type_selector])?
            },
        };
        let lhs_type = ReferenceType::new_mut_ref_type(&wanted_type);
        let rhs_type = wanted_type;
        let subtrees = vec![
            Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                AnyConstraint::new().with("type", lhs_type.clone()),
            ),
            Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                AnyConstraint::new().with("type", rhs_type.clone()),
            ),
        ];
        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let mut iter = asts.into_iter();
        let lhs_inner = iter.next().unwrap().into_expression().unwrap();
        let lhs = Dereference(Box::new(lhs_inner)).into();
        let rhs = iter.next().unwrap().into_expression().unwrap();
        let assignment = Assignment::AssignDeref(Box::new(lhs), Box::new(rhs));
        Ok(assignment.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast.as_assignment() {
            Some(Assignment::AssignDeref(_, _)) => true,
            _ => false,
        }
    }
}
