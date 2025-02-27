use super::ExprOfTypeGenerator;
use crate::{
    move_ast::{FunctionCall, MoveAST},
    states::{get_curr_scope, get_id_pool, get_type_pool, FunctionType, Id},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct FuncCallGenerator;

impl LabelledGenerator for FuncCallGenerator {
    fn label() -> GenLabel {
        GenLabel::new("FuncCallGenerator")
    }
}

impl Register<GeneratorEntry> for FuncCallGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for FuncCallGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        let curr_scope_id = get_curr_scope(env).get_last_scope_id();
        let curr_func_id = get_id_pool(env).get_func_scope_id_of(&curr_scope_id);
        let callable = get_type_pool(env).all_callable_function_within(&curr_func_id);
        if callable.is_empty() {
            return false;
        }
        if let Some(name) = constraint.get::<Id>("name") {
            callable.iter().any(|f| f.name == *name)
        } else {
            true
        }
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let curr_scope_id = get_curr_scope(env).get_last_scope_id();
        let curr_func_id = get_id_pool(env).get_func_scope_id_of(&curr_scope_id);
        let callable = get_type_pool(env).all_callable_function_within(&curr_func_id);

        let chosen = match constraint.get::<Id>("name") {
            Some(name) => callable.into_iter().find(|f| f.name == *name).unwrap(),
            None => u.choose(&callable)?.clone(),
        };

        let mut subtrees = vec![];
        for arg_type in &chosen.params {
            let gen_constraints = AnyConstraint::new().with("type", arg_type.clone());
            subtrees.push(Subtree::new_generator_subtree(
                ExprOfTypeGenerator::label(),
                gen_constraints,
            ));
        }
        let comp_constraints = AnyConstraint::new().with("func", chosen);
        Ok((subtrees, comp_constraints))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let arguments = asts
            .into_iter()
            .map(|ast| ast.as_expression().unwrap().clone())
            .collect();
        let func_type = constraint.get::<FunctionType>("func").unwrap().clone();
        Ok(FunctionCall {
            func_type,
            arguments,
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
        ast.as_functioncall().is_some()
    }
}
