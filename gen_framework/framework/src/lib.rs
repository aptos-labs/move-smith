use std::cell::{Ref, RefCell, RefMut};

pub mod ast;
pub mod codegen;
pub mod config;
pub mod consts;
pub mod curr_scope;
pub mod env;
pub mod generator;
pub mod ids;
pub mod label;
pub mod scope;
pub mod selection;
pub mod types;

use anyhow::{anyhow, Result};
use arbitrary::Unstructured;
use ast::{ASTNode, Program};
use env::Environment;
use generator::{Constraint, GeneratorPool, Subtree};
use label::GenLabel;
use log::{debug, info, trace};
use selection::choose_idx_filter;

pub struct Framework {
    pool: GeneratorPool,
    pub env: RefCell<Environment>,
}

impl Framework {
    pub fn new() -> Self {
        Framework {
            pool: GeneratorPool::new(),
            env: RefCell::new(Environment::new()),
        }
    }

    pub fn env(&self) -> Ref<Environment> {
        self.env.borrow()
    }

    pub fn env_mut(&self) -> RefMut<Environment> {
        self.env.borrow_mut()
    }

    /// This generates the whole program
    pub fn generate_program(&self, u: &mut Unstructured) -> Result<Program> {
        let mut prog = Program::new();

        // Generate Structs

        let type_generators: Vec<GenLabel> = self
            .pool
            .generators()
            .into_iter()
            .filter(|g| g.type_def)
            .collect();
        debug!("Got {} type generators", type_generators.len());

        let num_structs = self.env_mut().config().num_structs.select(u)?;
        info!("Generating {} types", num_structs);
        for _ in 0..num_structs {
            let gen = u.choose(&type_generators).unwrap();
            let struct_def = self.generate(u, &prog, &gen, &Constraint::default())?;
            prog.structs.push(struct_def);
        }

        // Generate Functions
        let func_generators: Vec<GenLabel> = self
            .pool
            .generators()
            .into_iter()
            .filter(|g| g.func_def)
            .collect();
        debug!("Got {} function generators", type_generators.len());

        let num_funcs = self.env_mut().config().num_funcs.select(u)?;
        info!("Generating {} functions", num_funcs);

        for _ in 0..num_funcs {
            let gen = u.choose(&func_generators).unwrap();
            let func_def = self.generate(u, &prog, &gen, &Constraint::default())?;
            prog.functions.push(func_def);
        }
        Ok(prog)
    }

    /// Uses the Generator trait to generate an ASTNode.
    /// Should have been put in the Generator trait with this as the default implementation.
    /// but it should not be changed by any generator so it is here.
    /// This uses one generator to generate a single partial ASTNode at a time.
    pub fn generate(
        &self,
        u: &mut Unstructured,
        prog: &Program,
        base_label: &GenLabel,
        constraint: &Constraint,
    ) -> Result<ASTNode> {
        trace!("Generating ASTNode with label: {}", base_label);

        // The constraint should be at least be well-formed for the base label
        let generator = self.pool.get(&base_label).unwrap();
        if !generator.check_constraint(self.env(), constraint) {
            return Err(anyhow!(
                "Constraint not well-formed for base generator{:?}\n{:?}",
                base_label,
                constraint
            ));
        }

        // For all the usable generators, randomly select one that the constraint is well-formed for
        // If none of the specialized generators can be used, we will fall back to the base generator
        let usable_generators: Vec<GenLabel> = self.pool.generators_from(base_label);
        let selected_idx = choose_idx_filter(u, &usable_generators, |g| {
            self.pool
                .get(g)
                .unwrap()
                .check_constraint(self.env(), constraint)
        })?
        .unwrap();
        let selected_label = &usable_generators[selected_idx];
        trace!("Selected generator: {:?}", selected_label);

        // TODO: on only the selected generator or also its parent (or plus all its siblings)
        self.env_mut().update_pre(u, prog, selected_label);

        // Register the subtrees
        let generator = self.pool.get(selected_label).unwrap();
        let subtrees = generator.subtrees(u, self.env_mut(), constraint);

        let mut asts = vec![];

        for s in subtrees {
            match s {
                Subtree::Candidates(mut c) => {
                    let idx = u.choose_index(c.candidates.len()).unwrap();
                    asts.push(c.candidates.remove(idx));
                },
                Subtree::Generator(g) => {
                    asts.push(self.generate(u, &prog, &g.generator_label, &g.constraints)?);
                },
            }
        }

        let new_node = generator.compose(u, self.env_mut(), asts);

        // Use the original given generator to check if the newly created node follows the constraints
        let result =
            self.pool
                .get(&base_label)
                .unwrap()
                .check_ast(self.env(), constraint, new_node.clone());
        // TODO: use reference
        if !result {
            return Err(anyhow!(
                "Generated ASTNode does not follow the constraints for label {:?}:\n{:?}",
                base_label,
                new_node
            ));
        }

        self.env_mut()
            .update_post(u, prog, &new_node, selected_label);

        Ok(new_node)
    }
}
