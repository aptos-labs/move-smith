use crate::{
    generators::CallArgumentsGenerator,
    move_ast::{
        Block, Callable, Function, FunctionCall, MoveAST, Sequence, Signature, Statement,
        TypeParameters,
    },
    states::{
        new_id_from_curr_scope, new_id_from_curr_scope_and_push_scope, pop_scope, Depth, Id,
        IdKind, Type,
    },
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct RunnerGenerator;

impl LabelledGenerator for RunnerGenerator {
    fn label() -> GenLabel {
        GenLabel::new("RunnerGenerator")
    }
}

impl Register<GeneratorEntry> for RunnerGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for RunnerGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<Callable>("callable")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (new_name, _, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Function);
        env.get_mut::<Depth>().unwrap().expr_depth.set_max_depth(0);

        let callable = constraint.get::<Callable>("callable").unwrap();
        let subtrees = vec![Subtree::new_generator_subtree(
            CallArgumentsGenerator::label(),
            AnyConstraint::new().with("callable", callable.clone()),
        )];

        let comp_constraint = AnyConstraint::new()
            .with("callable", callable.clone())
            .with("name", new_name);
        Ok((subtrees, comp_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        env.get_mut::<Depth>().unwrap().expr_depth.reset_max_depth();
        let (block_id, _) = new_id_from_curr_scope(env, IdKind::Block);
        pop_scope(env);

        let runner_name = constraint.get::<Id>("name").unwrap();
        let callable = constraint.get::<Callable>("callable").unwrap();
        let callargs = asts
            .into_iter()
            .next()
            .unwrap()
            .into_callarguments()
            .unwrap();

        let func = Function {
            signature: Signature {
                name: runner_name.clone(),
                type_params: TypeParameters::default(),
                parameters: vec![],
                return_type: Type::Unit,
                abilities: vec![],
                is_func_value: false,
            },
            body: Block {
                name: block_id,
                sequences: vec![Sequence {
                    statements: vec![Statement::Expression(
                        FunctionCall {
                            callable: callable.clone(),
                            args: callargs,
                        }
                        .into(),
                    )],
                }],
                return_expr: None,
            },
        };
        Ok(func.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_function().is_some()
    }
}
