use arbitrary::Unstructured;
use framework::{
    ast::{ASTNode, Function},
    consts::{HAS_RET_TYPE, RET_TYPE},
    env::Environment,
    generator::{Constraint, Generator, GeneratorT, Subtree, GENERATORS},
    ids::{IDKind, ID, ROOT_SCOPE},
    label::GenLabel,
};
use linkme::distributed_slice;
use log::trace;
use std::{
    cell::{Ref, RefCell, RefMut},
    vec,
};

#[derive(Clone, Default)]
pub struct FunctionGenerator {
    name: RefCell<ID>,
}

impl Generator for FunctionGenerator {
    fn check_constraint(&self, _env: Ref<Environment>, constraint: &Constraint) -> bool {
        if let Some(_has_ret) = constraint.boolean.get(HAS_RET_TYPE) {
            if !constraint.types.contains_key(RET_TYPE) {
                return false;
            }
        }
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        mut env: RefMut<Environment>,
        constraint: &Constraint,
    ) -> Vec<Subtree> {
        let (name, func_scope) = env.id_pool().next_id(IDKind::Function, &ROOT_SCOPE);
        *self.name.borrow_mut() = name;
        env.curr_scope().push(func_scope);

        if let Some(ret_type) = constraint.types.get(RET_TYPE) {
            // We don't need to do anything further since block and func use the same constraint
            trace!("FunctionGenerator: return type: {:?}", ret_type);
        }

        vec![Subtree::new_generator_subtree(
            GenLabel::new("BlockGenerator"),
            constraint.clone(),
        )]
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        _env: RefMut<Environment>,
        asts: Vec<ASTNode>,
    ) -> ASTNode {
        assert!(asts.len() == 1);
        let block = asts[0].clone();
        ASTNode::Function(Function {
            name: self.name.borrow().clone(),
            body: Box::new(block),
        })
    }

    fn check_ast(&self, env: Ref<Environment>, constraint: &Constraint, ast: ASTNode) -> bool {
        match ast {
            ASTNode::Function(func) => match *func.body {
                ASTNode::Block(_) => true,
                _ => false,
            },
            _ => false,
        }
    }
}

#[distributed_slice(GENERATORS)]
fn register_generator() -> (GenLabel, GeneratorT, Option<GenLabel>) {
    (
        GenLabel::new_func_def("FunctionGenerator"),
        Box::new(FunctionGenerator::default()),
        None,
    )
}
