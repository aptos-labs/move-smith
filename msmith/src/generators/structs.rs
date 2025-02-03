use crate::{
    move_ast::{MoveAST, Struct, TypeParameters},
    CurrScope, GenerationConfig, IdKind, IdPool, StructFieldGenerator,
};
use anyhow::{Ok, Result};
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct StructGenerator;

impl Labelled for StructGenerator {
    fn label() -> Label {
        GenLabel::new_module_member_level("StructGenerator").into()
    }
}

impl Register<GeneratorEntry> for StructGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
            forward: false,
        }
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
        let curr_scope = env.get::<CurrScope>().unwrap().get();
        let (name, scope) = env
            .get_mut::<IdPool>()
            .unwrap()
            .next_id(IdKind::Struct, &curr_scope);
        env.get_mut::<CurrScope>().unwrap().push(scope);

        let config = env.get::<GenerationConfig>().unwrap();
        let num_fields = config.num_fields_in_struct.select(u)?;

        let mut subtrees = vec![];
        for _ in 0..num_fields {
            subtrees.push(Subtree::new_generator_subtree(
                StructFieldGenerator::label().try_into().unwrap(),
                AnyConstraint::new(),
            ));
        }

        let partial_struct = Struct {
            name: name.clone(),
            type_params: TypeParameters::default(),
            fields: vec![],
            abilities: vec![],
        };

        let mut compose_constraint = AnyConstraint::new();
        compose_constraint.insert("struct", partial_struct);
        Ok((subtrees, compose_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        _asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
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
