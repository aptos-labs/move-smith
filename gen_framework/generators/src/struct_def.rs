use arbitrary::Unstructured;
use framework::{
    ast::{ASTNode, Struct, StructField},
    env::Environment,
    generator::{CandidateSubtree, Constraint, Generator, GeneratorT, Subtree, GENERATORS},
    ids::{IDKind, ROOT_SCOPE},
    label::GenLabel,
};
use linkme::distributed_slice;
use std::cell::{Ref, RefMut};

#[derive(Clone)]
pub struct StructDef;

impl Generator for StructDef {
    fn check_constraint(&self, _env: Ref<Environment>, _constraint: &Constraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        mut env: RefMut<Environment>,
        _constraint: &Constraint,
    ) -> Vec<Subtree> {
        let (name, struct_scope) = env.id_pool().next_id(IDKind::Struct, &ROOT_SCOPE);
        let num_fields = env.config().num_fields.select(u).unwrap();
        let mut fields = vec![];

        for _ in 0..num_fields {
            let (field_name, _) = env.id_pool().next_id(IDKind::Field, &struct_scope);

            let field_ty = env.type_pool().random_primitive_type(u).unwrap();

            fields.push(StructField {
                name: field_name,
                ty: field_ty,
            });
        }

        let node = ASTNode::Struct(Struct { name, fields });

        vec![Subtree::Candidates(CandidateSubtree {
            candidates: vec![node],
        })]
    }

    fn compose(
        &self,
        u: &mut Unstructured,
        _env: RefMut<Environment>,
        mut asts: Vec<ASTNode>,
    ) -> ASTNode {
        let idx = u.choose_index(asts.len()).unwrap();
        asts.remove(idx)
    }

    fn check_ast(&self, _env: Ref<Environment>, _constraint: &Constraint, _ast: ASTNode) -> bool {
        true
    }
}

#[distributed_slice(GENERATORS)]
fn register_generator() -> (GenLabel, GeneratorT, Option<GenLabel>) {
    (
        GenLabel::new_type_def("StructDef"),
        Box::new(StructDef),
        None,
    )
}
