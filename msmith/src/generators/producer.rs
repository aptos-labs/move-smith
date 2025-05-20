use crate::{
    generators::ExprOfTypeGenerator,
    move_ast::{Block, Function, MoveAST, Signature, TypeParameters, Visibility},
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
pub struct ProducerGenerator;

impl LabelledGenerator for ProducerGenerator {
    fn label() -> GenLabel {
        GenLabel::new("ProducerGenerator")
    }
}

impl Register<GeneratorEntry> for ProducerGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for ProducerGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, constraint: &AnyConstraint) -> bool {
        constraint.check_exist_and_type::<Type>("type")
    }

    fn subtrees(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (new_name, _, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Function);
        env.get_mut::<Depth>().unwrap().expr_depth.set_max_depth(0);

        let subtrees = vec![Subtree::new_generator_subtree(
            ExprOfTypeGenerator::label(),
            constraint.clone(),
        )];

        Ok((subtrees, constraint.clone().with("name", new_name)))
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

        let name = constraint.get::<Id>("name").unwrap().clone();
        let return_type = constraint.get::<Type>("type").unwrap().clone();
        let return_expr = asts.into_iter().next().unwrap().into_expression().unwrap();
        let func = Function {
            visibility: Visibility::Public,
            signature: Signature {
                name,
                type_params: TypeParameters::default(),
                parameters: vec![],
                return_type,
                abilities: vec![],
                is_func_value: false,
            },
            body: Block {
                name: block_id,
                sequences: vec![],
                return_expr: Some(Box::new(return_expr)),
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
