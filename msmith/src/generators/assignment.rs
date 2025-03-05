use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{
        Assignment, Expression, MoveAST, SingleVariable, StructDestructure, Tuple, Variable,
    },
    states::{
        get_config, get_type_pool, new_id_from_curr_scope, ConcreteType, GenericType, IdKind, Type,
        TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use std::collections::BTreeMap;

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
                    .func_return(1)
                    .structs(1)
                    .enums(1)
                    .build();
                get_type_pool(env).random_type(u, vec![type_selector])?
            },
        };

        let gen_constraint = AnyConstraint::new().with("type", wanted_type.clone());
        let subtree =
            Subtree::new_generator_subtree(ExprOfTypeGenerator::label(), gen_constraint.clone());

        Ok((vec![subtree], gen_constraint))
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let typ = constraint.get::<Type>("type").unwrap();
        let special_lhs = match typ {
            Type::Generic(GenericType::Tuple(t)) => {
                let mut exprs = vec![];
                for elem_typ in &t.types {
                    let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
                    let var: Variable = SingleVariable::new(&name, elem_typ).into();
                    let expr: Expression = var.into();
                    exprs.push(expr);
                }
                Some(
                    Tuple {
                        expressions: exprs,
                        show_type: true,
                    }
                    .into(),
                )
            },
            Type::Generic(GenericType::Struct(s)) => {
                if u.arbitrary::<bool>()? {
                    let mut new_vars = vec![];
                    for (_, field_type) in &s.fields {
                        let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
                        let mut var = SingleVariable::new_declare(&name, field_type);
                        var.show_type = false;
                        new_vars.push(var.into());
                    }
                    Some(
                        StructDestructure {
                            struct_type: ConcreteType {
                                mapping: BTreeMap::new(),
                                typ: Box::new(typ.clone()),
                            },
                            new_vars,
                        }
                        .into(),
                    )
                } else {
                    None
                }
            },
            _ => None,
        };

        let lhs = match special_lhs {
            Some(lhs) => lhs,
            None => {
                let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
                let var: Variable = SingleVariable::new_declare(&name, typ).into();
                var.into()
            },
        };

        let rhs = asts.into_iter().next().unwrap().into_expression().unwrap();
        Ok(Assignment {
            lhs: Box::new(lhs),
            rhs: Box::new(rhs),
        }
        .into())
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
