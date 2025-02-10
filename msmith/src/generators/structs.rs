use crate::{
    move_ast::{MoveAST, Struct, TypeParameters},
    states::{get_config, new_id_from_curr_scope_and_push_scope, pop_scope, IdKind},
    StructFieldGenerator,
};
use anyhow::{Ok, Result};
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct StructGenerator;

impl LabelledGenerator for StructGenerator {
    fn label() -> GenLabel {
        GenLabel::new_module_member_level("StructGenerator")
    }
}

impl Register<GeneratorEntry> for StructGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
    }
}

impl Generator<MoveAST, AnyConstraint> for StructGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (name, _scope, _) = new_id_from_curr_scope_and_push_scope(env, IdKind::Struct);

        let num_fields = get_config(env).num_fields_in_struct.select(u)?;

        let mut subtrees = vec![];
        for _ in 0..num_fields {
            subtrees.push(Subtree::new_generator_subtree(
                StructFieldGenerator::label(),
                AnyConstraint::new(),
            ));
        }

        let partial_struct = Struct {
            name: name.clone(),
            type_params: TypeParameters::default(),
            fields: vec![],
            abilities: vec![],
        };

        let compose_constraint = AnyConstraint::new().with("struct", partial_struct);
        Ok((subtrees, compose_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        _asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        pop_scope(env);
        let partial_struct = constraint.get::<Struct>("struct").unwrap().clone();
        Ok(partial_struct.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_struct().is_some()
    }
}
