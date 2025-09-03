use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Expression, MoveAST, Variable},
    states::{get_curr_scope, get_current_info, get_named_infos, Type, Typed},
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

fn get_usable_variables(
    env: &StatePool<MoveAST>,
    constraint: &AnyConstraint,
) -> Option<Vec<Variable>> {
    let will_mut = constraint.get::<bool>("will_mut").unwrap_or(&false);
    let curr_scope = get_curr_scope(env);
    let in_lambda = get_current_info(env).is_in_lambda();
    let typ = constraint.get::<Type>("type")?;

    let vars = if in_lambda {
        get_named_infos(env).get_initialized_vars_for_lambda(&curr_scope, typ, *will_mut)
    } else {
        get_named_infos(env).get_initialized_vars_of_type(&curr_scope, typ)
    };
    trace!(
        "[Finding usable vars] in_lambda: {in_lambda}, will_mut: {will_mut}: found {} usable vars",
        vars.len()
    );
    Some(vars)
}

impl Generator<MoveAST, AnyConstraint> for EOTVariableGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        get_usable_variables(env, constraint).map_or(false, |v| !v.is_empty())
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let vars = get_usable_variables(env, constraint).unwrap();
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
