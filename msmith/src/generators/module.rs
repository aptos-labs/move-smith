use crate::{
    generators::{FunctionGenerator, StructGenerator},
    move_ast::{Address, MoveAST, MoveModule},
    states::ids::ROOT_SCOPE,
    CurrScope, GenerationConfig, Id, IdPool,
};
use anyhow::{anyhow, Result};
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, Label, Labelled, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct ModuleGenerator {
    name: Id,
    num_structs: usize,
    num_funcs: usize,
}

impl Labelled for ModuleGenerator {
    fn label() -> Label {
        GenLabel::new_top_level("ModuleGenerator").into()
    }
}

impl Register<GeneratorEntry> for ModuleGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for ModuleGenerator {
    fn check_constraint(&self, _env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        true
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let (name, scope) = env
            .get_mut::<IdPool>()
            .unwrap()
            .next_id(crate::IdKind::Module, &ROOT_SCOPE);

        env.get_mut::<CurrScope>().unwrap().push(scope);

        let mut subtrees = vec![];

        let config = env.get::<GenerationConfig>().unwrap();
        let num_structs = config.num_structs_in_module.select(u)?;
        let num_funcs = config.num_functions_in_module.select(u)?;

        for _ in 0..num_structs {
            subtrees.push(Subtree::new_generator_subtree(
                StructGenerator::label().try_into().unwrap(),
                AnyConstraint::new(),
            ));
        }

        for _ in 0..num_funcs {
            subtrees.push(Subtree::new_generator_subtree(
                FunctionGenerator::label().try_into().unwrap(),
                AnyConstraint::new(),
            ));
        }

        let mut compose_constraint = AnyConstraint::new();
        compose_constraint.insert("name", name);

        Ok((subtrees, compose_constraint))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        env.get_mut::<CurrScope>().unwrap().pop();
        let mut structs = vec![];
        let mut functions = vec![];
        for node in asts {
            match node {
                MoveAST::Struct(s) => structs.push(s),
                MoveAST::Function(f) => functions.push(f),
                _ => return Err(anyhow!("Unexpected AST node")),
            }
        }
        Ok(MoveModule {
            address: Address::default(),
            name: constraint.get::<Id>("name").unwrap().clone(),
            structs,
            functions,
        }
        .into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_movemodule().is_some()
    }
}
