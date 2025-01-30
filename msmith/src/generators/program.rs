use super::ModuleGenerator;
use crate::{
    move_ast::{MoveAST, Program},
    GenerationConfig,
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    label::{GenLabel, Label, Labelled},
    AnyConstraint, Generator, GeneratorEntry, Register, StatePool, Subtree,
};
use log::trace;

#[derive(Default)]
pub struct ProgramGenerator;

impl Labelled for ProgramGenerator {
    fn label() -> Label {
        GenLabel::new_top_level("ProgramGenerator").into()
    }
}

impl Register<GeneratorEntry> for ProgramGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry {
            label: Self::label().try_into().unwrap(),
            parents: vec![],
        }
    }
}

impl Generator<MoveAST, AnyConstraint> for ProgramGenerator {
    fn check_constraint(&self, env: &StatePool<MoveAST>, _constraint: &AnyConstraint) -> bool {
        env.get::<GenerationConfig>().is_some()
    }

    fn subtrees(
        &self,
        u: &mut Unstructured,
        env: &mut StatePool<MoveAST>,
        _constraint: &AnyConstraint,
    ) -> Result<(Vec<Subtree<MoveAST, AnyConstraint>>, AnyConstraint)> {
        let config = env.get::<GenerationConfig>().unwrap();
        let num_modules = config.num_modules.select(u)?;
        trace!("Generating {} modules", num_modules);
        let mut subtrees = vec![];

        // TODO: we generate 1 module for now so no need to let them reference each other
        for _ in 0..num_modules {
            let module_gen = ModuleGenerator::label().try_into().unwrap();
            let constraints = AnyConstraint::new();
            let subtree = Subtree::new_generator_subtree(module_gen, constraints);
            subtrees.push(subtree);
        }

        Ok((subtrees, AnyConstraint::new()))
    }

    fn compose(
        &self,
        _u: &mut Unstructured,
        _env: &mut StatePool<MoveAST>,
        _constraint: AnyConstraint,
        asts: Vec<MoveAST>,
    ) -> Result<MoveAST> {
        let modules = asts
            .into_iter()
            .map(|ast| ast.try_into().unwrap())
            .collect();
        let prog = Program { modules };
        Ok(prog.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_program().is_some()
    }
}
