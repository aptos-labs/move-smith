use crate::{
    generators::{ModuleGenerator, ScriptGenerator},
    move_ast::{MoveAST, Program},
    states::{get_config, get_config_mut, Depth, GenerationConfig},
};
use anyhow::Result;
use arbitrary::Unstructured;
use framework::{
    label::{GenLabel, LabelledGenerator},
    AnyConstraint, Generator, GeneratorEntry, Register, StatePool, Subtree,
};
use log::trace;

#[derive(Default)]
pub struct ProgramGenerator;

impl LabelledGenerator for ProgramGenerator {
    fn label() -> GenLabel {
        GenLabel::new_top_level("ProgramGenerator")
    }
}

impl Register<GeneratorEntry> for ProgramGenerator {
    fn register(&self) -> GeneratorEntry {
        GeneratorEntry::new::<Self>()
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
        // Setting up states

        let mut expr_depths = vec![];
        for _ in 0..10 {
            expr_depths.push(get_config_mut(env).expr_depth.select(u)?)
        }
        env.get_mut::<Depth>()
            .unwrap()
            .expr_depth
            .initialize(expr_depths);

        let num_modules = get_config(env).num_modules.select(u)?;
        trace!("Generating {num_modules} modules");
        let mut subtrees = vec![];

        for _ in 0..num_modules {
            let module_gen = ModuleGenerator::label();
            let constraints = AnyConstraint::new();
            let subtree = Subtree::new_generator_subtree(module_gen, constraints);
            subtrees.push(subtree);
        }

        let num_scripts = get_config(env).num_scripts.select(u)?;
        trace!("Generating {num_scripts} scripts");
        for _ in 0..num_modules {
            let subtree =
                Subtree::new_generator_subtree(ScriptGenerator::label(), AnyConstraint::new());
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
        let mut modules = vec![];
        let mut scripts = vec![];
        for ast in asts {
            match ast {
                MoveAST::MoveModule(m) => modules.push(m),
                MoveAST::Script(s) => scripts.push(s),
                _ => unreachable!(),
            }
        }
        let prog = Program { modules, scripts };
        Ok(prog.into())
    }

    fn check_ast(
        &self,
        _env: &StatePool<MoveAST>,
        _gen_constraint: &AnyConstraint,
        _comp_constraint: &AnyConstraint,
        ast: &MoveAST,
    ) -> bool {
        ast.as_program().is_some()
    }
}
