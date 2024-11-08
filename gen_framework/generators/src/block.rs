use arbitrary::Unstructured;
use framework::{
    ast::{ASTNode, Block},
    consts::{HAS_RET_TYPE, RET_TYPE},
    env::Environment,
    generator::{Constraint, Generator, GeneratorT, Subtree, GENERATORS},
    label::GenLabel,
};
use linkme::distributed_slice;
use std::cell::{Ref, RefMut};

#[derive(Clone)]
pub struct BlockGenerator;

impl Generator for BlockGenerator {
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
        env: RefMut<Environment>,
        constraint: &Constraint,
    ) -> Vec<Subtree> {
        vec![Subtree::new_single_candidate(ASTNode::Block(Block {
            body: vec![],
            ret: None,
        }))]
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        env: RefMut<Environment>,
        mut asts: Vec<ASTNode>,
    ) -> ASTNode {
        asts.remove(0)
    }

    fn check_ast(&self, env: Ref<Environment>, constraint: &Constraint, ast: ASTNode) -> bool {
        true
    }
}

#[distributed_slice(GENERATORS)]
fn register_generator() -> (GenLabel, GeneratorT, Option<GenLabel>) {
    (
        GenLabel::new("BlockGenerator"),
        Box::new(BlockGenerator),
        None,
    )
}
