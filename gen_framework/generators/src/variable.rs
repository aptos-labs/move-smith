use arbitrary::Unstructured;
use framework::{
    ast::ASTNode,
    env::Environment,
    generator::{CandidateSubtree, Constraint, Generator, GeneratorT, Subtree, GENERATORS},
    label::GenLabel,
};
use linkme::distributed_slice;
use std::cell::{Ref, RefMut};

#[derive(Clone)]
pub struct VariableAccess {
    pub name: String,
}

impl VariableAccess {
    pub fn new() -> Self {
        VariableAccess {
            name: "var".to_string(),
        }
    }
}

impl Generator for VariableAccess {
    fn check_constraint(&self, env: Ref<Environment>, constraint: &Constraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: RefMut<Environment>,
        constraint: &Constraint,
    ) -> Vec<Subtree> {
        vec![]
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        env: RefMut<Environment>,
        asts: Vec<ASTNode>,
    ) -> ASTNode {
        ASTNode::empty()
    }

    fn check_ast(&self, env: Ref<Environment>, constraint: &Constraint, ast: ASTNode) -> bool {
        true
    }
}

#[distributed_slice(GENERATORS)]
fn register_generator() -> (GenLabel, GeneratorT, Option<GenLabel>) {
    (
        GenLabel::new_top_level("VariableAccess"),
        Box::new(VariableAccess::new()),
        None,
    )
}
