use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Expression, MoveAST},
    states::{get_curr_scope, get_named_infos, Type, Typed},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::trace;

/// Generate a variable of the given type.
#[derive(Default)]
pub struct EOTVariableGenerator;

impl LabelledGenerator for EOTVariableGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTVariableGenerator")
    }
}

impl Register<GeneratorEntry> for EOTVariableGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTVariableGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        match constraint.get::<Type>("type") {
            Some(typ) => {
                let curr_scope = get_curr_scope(env);
                let vars = get_named_infos(env).get_initialized_vars_of_type(&curr_scope, typ);
                trace!("Finding vars of type {:?}: {:?}", typ, vars);
                !vars.is_empty()
            },
            None => false,
        }
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let picked_typ = constraint.get::<Type>("type").unwrap();
        let curr_scope = get_curr_scope(env);
        let vars = get_named_infos(env).get_initialized_vars_of_type(&curr_scope, picked_typ);
        let chosen_var = u.choose(&vars)?.clone();

        let subtree = Subtree::new_single_candidate(chosen_var.into());
        Ok((vec![subtree], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let var = asts.into_iter().next().unwrap().into_variable().unwrap();
        Ok(Expression::Variable(var).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast.as_expression().as_ref() {
            Some(Expression::Variable(v)) => {
                if let Some(t) = gen_constraint.get::<Type>("type") {
                    t == &v.ty()
                } else {
                    true
                }
            },
            _ => false,
        }
    }
}
