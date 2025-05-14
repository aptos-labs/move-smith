use crate::{
    generators::{CallArgumentsGenerator, PatternGenerator, StatementGenerator},
    move_ast::{Assignment, Callable, FunctionCall, MoveAST, Statement},
    states::{get_curr_scope, get_named_infos, NamedInfo},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};
use std::cell::RefCell;

#[derive(Default)]
pub struct LetCallGenerator {
    funcs: RefCell<Vec<NamedInfo>>,
}

impl LabelledGenerator for LetCallGenerator {
    fn label() -> GenLabel {
        GenLabel::new_func_body_level("LetCallGenerator")
    }
}

impl Register<GeneratorEntry> for LetCallGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>().with_parent::<StatementGenerator>()
    }
}

impl Generator<MoveAST, AnyConstraint> for LetCallGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        let curr_scope = get_curr_scope(env);
        let callables = get_named_infos(env).get_callable_info(&curr_scope);
        let normal_funcs = callables
            .into_iter()
            .filter(|info| !info.typ.as_function().unwrap().is_func_value)
            .collect::<Vec<_>>();
        if normal_funcs.is_empty() {
            return false;
        }
        *self.funcs.borrow_mut() = normal_funcs;
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let funcs = self.funcs.borrow();
        let chosen = u.choose(&funcs)?.clone();
        let callable = Callable {
            expr: Box::new(chosen.to_variable().into()),
            func_type: chosen.typ.as_function().unwrap().clone(),
        };
        let ret_type = chosen
            .typ
            .as_function()
            .unwrap()
            .return_type
            .as_ref()
            .clone();
        let subtrees = vec![
            Subtree::new_generator_subtree(
                PatternGenerator::label(),
                AnyConstraint::new()
                    .with("type", ret_type)
                    .with("no_partial", true),
            ),
            Subtree::new_generator_subtree(
                CallArgumentsGenerator::label(),
                AnyConstraint::new().with("callable", callable.clone()),
            ),
        ];
        Ok((subtrees, AnyConstraint::new().with("callable", callable)))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let mut iter = asts.into_iter();
        let pattern = iter.next().unwrap().into_pattern().unwrap();
        let args = iter.next().unwrap().into_callarguments().unwrap();
        let callable = constraint.get::<Callable>("callable").unwrap().clone();
        let call = FunctionCall { callable, args };
        let assign = Assignment::AssignPattern(pattern, Box::new(call.into()));
        Ok(Statement::LetAssign(assign).into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        matches!(ast, MoveAST::Statement(Statement::LetAssign(_)))
    }
}
