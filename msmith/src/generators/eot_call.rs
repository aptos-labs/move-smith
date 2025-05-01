use crate::{
    generators::{CallArgumentsGenerator, CallableGenerator, ExprOfTypeGenerator},
    move_ast::{Expression, FunctionCall, MoveAST},
    states::{get_current_info, Type},
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
        GenLabel::new("EOTFuncCallGenerator")
    }
}

impl Register<GeneratorEntry> for EOTFuncCallGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<ExprOfTypeGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for EOTFuncCallGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        // The desired return type of this call
        constraint.check_exist_and_type::<Type>("type")
            && get_current_info(env).func_call_nesting_depth <= 4
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let subtrees = vec![
            Subtree::new_generator_subtree(CallableGenerator::label(), constraint.clone()),
            Subtree::new_generator_subtree(CallArgumentsGenerator::label(), AnyConstraint::new()),
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
        let callable = iter.next().unwrap().into_callable().unwrap();
        let args = iter.next().unwrap().into_callarguments().unwrap();
        let call = FunctionCall { callable, args };
        Ok(Expression::FunctionCall(call).into())
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
