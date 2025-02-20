use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Expression, MoveAST, Variable},
    states::{get_type_pool, get_vars_in_curr_scope_of_type, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use log::{trace, warn};

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
        warn!("EOTVariableGenerator::check_constraint is not complete");
        constraint.check_not_exist_or_has_type::<Type>("type") && {
            let typ = constraint.get::<Type>("type");
            let vars = get_vars_in_curr_scope_of_type(env, typ);
            trace!("Finding vars of type {:?}: {:?}", typ, vars);
            for var in &get_vars_in_curr_scope_of_type(env, None) {
                let var_typ = get_type_pool(env).get_var_type(var);
                trace!("Var {} has type {:?}", var, var_typ);
            }
            !vars.is_empty()
        }
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let picked_typ = constraint.get::<Type>("type").cloned();
        let vars = get_vars_in_curr_scope_of_type(env, picked_typ.as_ref());
        let name = u.choose(&vars)?.clone();
        let typ = get_type_pool(env).get_var_type(&name).unwrap().clone();
        let subtree = Subtree::new_single_candidate(
            Variable {
                name,
                typ,
                declare: false,
                show_type: false,
            }
            .into(),
        );
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
                    t == &v.typ
                } else {
                    true
                }
            },
            _ => false,
        }
    }
}
