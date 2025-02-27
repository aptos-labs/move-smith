use super::{ExprOfTypeGenerator, FuncCallGenerator};
use crate::{
    move_ast::{Expression, MoveAST},
    states::{get_curr_scope, get_id_pool, get_type_pool, FunctionType, Type},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct EOTFuncCallGenerator;

impl LabelledGenerator for EOTFuncCallGenerator {
    fn label() -> GenLabel {
        GenLabel::new("EOTFuncCall")
    }
}

impl Register<GeneratorEntry> for EOTFuncCallGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTFuncCallGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        let curr_scope_id = get_curr_scope(env).get_last_scope_id();
        let curr_func_id = get_id_pool(env).get_func_scope_id_of(&curr_scope_id);
        let callable = get_type_pool(env).all_callable_function_within(&curr_func_id);

        let typ = _constraint.get::<Type>("type").unwrap();
        let type_ok_funcs = callable
            .into_iter()
            .filter(|f| f.return_type.as_ref() == typ)
            .collect::<Vec<FunctionType>>();
        !type_ok_funcs.is_empty()
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let curr_scope_id = get_curr_scope(env).get_last_scope_id();
        let curr_func_id = get_id_pool(env).get_func_scope_id_of(&curr_scope_id);
        let callable = get_type_pool(env).all_callable_function_within(&curr_func_id);

        let typ = _constraint.get::<Type>("type").unwrap();
        let type_ok_funcs = callable
            .into_iter()
            .filter(|f| f.return_type.as_ref() == typ)
            .collect::<Vec<FunctionType>>();

        let chosen_name = u.choose(&type_ok_funcs)?.name.clone();
        let gen_constraint = AnyConstraint::new().with("name", chosen_name.clone());
        let subtree = Subtree::new_generator_subtree(FuncCallGenerator::label(), gen_constraint);
        Ok((vec![subtree], AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let call = asts
            .into_iter()
            .next()
            .unwrap()
            .into_functioncall()
            .unwrap();
        Ok(Expression::FunctionCall(call).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        match ast.as_expression() {
            Some(Expression::FunctionCall(_)) => true,
            _ => false,
        }
    }
}
