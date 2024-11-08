use arbitrary::Unstructured;
use framework::{
    ast::ASTNode,
    env::Environment,
    generator::{Constraint, Generator, GeneratorT, Subtree, GENERATORS},
    label::GenLabel,
};
use linkme::distributed_slice;
use std::cell::{Ref, RefMut};

#[derive(Clone)]
pub struct NewGenerator;

impl Generator for NewGenerator {
    fn check_constraint(&self, _env: Ref<Environment>, _constraint: &Constraint) -> bool {
        unimplemented!()
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: RefMut<Environment>,
        constraint: &Constraint,
    ) -> Vec<Subtree> {
        unimplemented!()
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        env: RefMut<Environment>,
        asts: Vec<ASTNode>,
    ) -> ASTNode {
        unimplemented!()
    }

    fn check_ast(&self, env: Ref<Environment>, constraint: &Constraint, ast: ASTNode) -> bool {
        unimplemented!()
    }
}

#[distributed_slice(GENERATORS)]
fn register_generator() -> (GenLabel, GeneratorT, Option<GenLabel>) {
    (GenLabel::new("NewGenerator"), Box::new(NewGenerator), None)
}
