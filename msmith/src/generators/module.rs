use crate::{
    generators::{FunctionGenerator, StructGenerator},
    move_ast::{Address, MoveAST, MoveModule},
    states::ids::ROOT_SCOPE,
    CurrScope, GenerationConfig, Id, IdPool,
};
use anyhow::{anyhow, Result};
use arbitrary::Unstructured;
use framework::{
    AnyConstraint, GenLabel, Generator, GeneratorEntry, LabelledGenerator, Register, StatePool,
    Subtree,
};

#[derive(Default)]
pub struct ModuleGenerator;

impl LabelledGenerator for ModuleGenerator {
    fn label() -> GenLabel {
        GenLabel::new_top_level("ModuleGenerator")
    }
}

impl Register<GeneratorEntry> for ModuleGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
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
                StructGenerator::label(),
                AnyConstraint::new(),
            ));
        }

        let mut func_constraints = AnyConstraint::new();
        func_constraints.insert("has_return", false);
        for _ in 0..num_funcs {
            subtrees.push(Subtree::new_generator_subtree(
                FunctionGenerator::label(),
                func_constraints.clone(),
            ));
        }

        let compose_constraint = AnyConstraint::new().with("name", name);

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
