use crate::{
    generators::RunnerGenerator,
    move_ast::{Callable, MoveAST, Runners},
    states::{get_config, get_curr_scope, get_named_infos},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct RunnersGenerator;

impl LabelledGenerator for RunnersGenerator {
    fn label() -> GenLabel {
        GenLabel::new("RunnersGenerator")
    }
}

impl Register<GeneratorEntry> for RunnersGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for RunnersGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let num_runs_per_func = get_config(env).num_runs_per_func.select(u)?;
        let curr_scope = get_curr_scope(env);
        let funcs = get_named_infos(env).get_all_normal_functions(&curr_scope);
        let callables = funcs
            .into_iter()
            .map(|func| Callable {
                expr: Box::new(func.to_variable().into()),
                func_type: func.typ.as_function().unwrap().clone(),
            })
            .collect::<Vec<Callable>>();
        let mut subtrees = vec![];
        for c in &callables {
            for _ in 0..num_runs_per_func {
                subtrees.push(Subtree::new_generator_subtree(
                    RunnerGenerator::label(),
                    AnyConstraint::new().with("callable", c.clone()),
                ));
            }
        }
        let comp_constraint = AnyConstraint::new().with("num_runs_per_func", num_runs_per_func);
        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let funcs = asts
            .into_iter()
            .map(|ast| ast.into_function().unwrap())
            .collect();
        Ok(Runners(funcs).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_runners().is_some()
    }
}
