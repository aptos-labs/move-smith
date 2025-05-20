use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{CallArguments, Callable, Expression, FunctionCall, MoveAST},
    states::{get_curr_scope, get_named_infos, Named, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTProducerCallGenerator;

impl LabelledGenerator for EOTProducerCallGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTProducerCallGenerator")
    }
}

impl Register<GeneratorEntry> for EOTProducerCallGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTProducerCallGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        let Some(typ) = constraint.get::<Type>("type") else {
            return false;
        };

        if !(typ.is_enum() || typ.is_struct()) {
            return false;
        }

        // Only needs to call producer for types defined in other modules
        let same_mod = typ.parent_scope().is_from_same_module(&get_curr_scope(env));
        !same_mod
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let wanted_type = constraint.get::<Type>("type").unwrap();
        let curr_scope = get_curr_scope(env);
        let callables = get_named_infos(env)
            .get_callable_info(&curr_scope)
            .into_iter()
            .filter(|info| {
                let Some(func_type) = info.typ.as_function() else {
                    return false;
                };

                let ret_typ = func_type.return_type.as_ref();
                let num_args = func_type.params.len();
                num_args == 0 && ret_typ == wanted_type
            })
            .collect::<Vec<_>>();

        if callables.is_empty() {
            return Err(anyhow::anyhow!(
                "No callable found for type {:?}",
                wanted_type
            ));
        }

        let chosen = u.choose(&callables).unwrap();
        let callable = Callable {
            expr: Box::new(chosen.to_variable().into()),
            func_type: chosen.typ.as_function().unwrap().clone(),
        };
        let args = CallArguments(vec![]);
        let call = FunctionCall { callable, args };
        let subtrees = vec![Subtree::new_single_candidate(
            Expression::FunctionCall(call).into(),
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
        Ok(asts.into_iter().next().unwrap())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_expression()
            .and_then(|e| e.as_functioncall())
            .is_some()
    }
}
