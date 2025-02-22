use crate::{
    generators::{ExprOfTypeGenerator, StatementGenerator},
    move_ast::{Assignment, Expression, MoveAST, SingleVariable, Statement, Tuple, Variable},
    states::{
        get_config, get_type_pool, new_id_from_curr_scope, GenericType, IdKind, Type,
        TypeSelectorBuilder,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::warn;

#[derive(Default)]
pub struct LetGenerator;

impl LabelledGenerator for LetGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("LetGenerator")
    }
}

impl Register<GeneratorEntry> for LetGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for LetGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        warn!("check_constraint not implemented for LetGenerator");
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let config = get_config(env);
        let type_selector = TypeSelectorBuilder::all_no(config)
            .number(1)
            .func_return(1)
            .struct_(1)
            .build();
        let typ = get_type_pool(env).random_type(u, vec![type_selector])?;

        let constraint = AnyConstraint::new().with("type", typ.clone());
        let subtree =
            Subtree::new_generator_subtree(ExprOfTypeGenerator::label(), constraint.clone());
        Ok((vec![subtree], constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let typ = constraint.get::<Type>("type").unwrap().clone();
        let lhs = Box::new(match typ {
            Type::Generic(GenericType::Tuple(t)) => {
                let mut exprs = vec![];
                for elem_typ in t.types {
                    let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
                    let var: Variable = SingleVariable::new(&name, &elem_typ).into();
                    let expr: Expression = var.into();
                    exprs.push(expr);
                }
                Expression::Tuple(Tuple {
                    expressions: exprs,
                    show_type: true,
                })
            },
            _ => {
                let (name, _) = new_id_from_curr_scope(env, IdKind::Var);
                let var: Variable = SingleVariable::new_declare(name, typ).into();
                var.into()
            },
        });
        let rhs = Box::new(asts.into_iter().next().unwrap().into_expression().unwrap());
        Ok(Statement::Let(Expression::Assignment(Assignment { lhs, rhs })).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast {
            MoveAST::Statement(Statement::Let(expr)) => match expr {
                Expression::Variable(_) => true,
                Expression::Assignment(_) => true,
                _ => false,
            },
            _ => false,
        }
    }
}
