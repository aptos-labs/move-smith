use crate::{
    constraints::Constraint,
    generator::{GeneratorPool, Subtree},
    label::{GenLabel, LabelledGenerator, LabelledState},
    selection::choose_idx_filter,
    states::{State, StatePool},
    ASTNode, Generator,
};
use anyhow::{anyhow, Result};
use arbitrary::Unstructured;
use log::trace;
use std::cell::{Ref, RefCell, RefMut};

pub struct FrameworkBuilder<A: ASTNode, C: Constraint> {
    framework: Framework<A, C>,
}

impl<A, C> FrameworkBuilder<A, C>
where
    A: ASTNode + 'static,
    C: Constraint,
{
    pub fn new() -> Self {
        Self {
            framework: Framework {
                generators: GeneratorPool::empty(),
                states: RefCell::new(StatePool::empty()),
            },
        }
    }

    /// Register one generator, requires the generator to have Default
    pub fn add_generator<T: Generator<A, C> + LabelledGenerator + Default + 'static>(
        mut self,
    ) -> Self {
        let generator = T::default();
        self.framework
            .generators
            .register_generator(Box::new(generator));
        self
    }

    /// Register a list of generator objects
    pub fn add_generators<T: Generator<A, C> + LabelledGenerator + 'static>(
        mut self,
        generators: Vec<T>,
    ) -> Self {
        for g in generators {
            self.framework.generators.register_generator(Box::new(g));
        }
        self
    }

    /// Register one state, requires the state to have Default
    pub fn add_state<T: State<A> + LabelledState + Default>(self) -> Self {
        let state = T::default();
        self.framework.states.borrow_mut().register_state(state);
        self
    }

    /// Register a list of state objects
    pub fn add_states<T: State<A> + LabelledState>(self, states: Vec<T>) -> Self {
        for s in states {
            self.framework.states.borrow_mut().register_state(s);
        }
        self
    }

    pub fn build(mut self) -> Framework<A, C> {
        if !self.framework.generators.initialize() {
            panic!("Failed to initialize the generator pool");
        }
        self.framework
    }
}

pub struct Framework<A: ASTNode, C: Constraint> {
    generators: GeneratorPool<A, C>,
    states: RefCell<StatePool<A>>,
}

impl<A, C> Framework<A, C>
where
    A: ASTNode + 'static,
    C: Constraint,
{
    pub fn states(&self) -> Ref<StatePool<A>> {
        self.states.borrow()
    }

    pub fn states_mut(&self) -> RefMut<StatePool<A>> {
        self.states.borrow_mut()
    }

    /// This uses one generator to generate a single ASTNode at a time.
    pub fn generate(
        &self,
        u: &mut Unstructured,
        base_label: &GenLabel,
        constraint: &C,
    ) -> Result<A> {
        trace!("Generating ASTNode with label: {}", base_label);

        // The constraint should be at least be well-formed for the base label
        let generator = self.generators.get(&base_label).unwrap();
        if !generator.check_constraint(&self.states(), constraint) {
            return Err(anyhow!(
                "Constraint not well-formed for base generator{:?}\n{:?}",
                base_label,
                constraint
            ));
        }

        // For all the usable generators, randomly select one that the constraint is well-formed for
        // If none of the specialized generators can be used, we will fall back to the base generator
        let usable_generators: Vec<GenLabel> = self.generators.generators_from(base_label, true);
        let selected_idx = choose_idx_filter(u, &usable_generators, |g| {
            self.generators
                .get(g)
                .unwrap()
                .check_constraint(&self.states(), constraint)
        })?
        .unwrap();
        let selected_label = &usable_generators[selected_idx];
        trace!("Selected generator: {:?}", selected_label);

        // TODO: on only the selected generator or also its parent (or plus all its siblings)
        let state_hook_generators = self.generators.generators_from(base_label, false);
        trace!("State hook generators: {:?}", state_hook_generators);
        trace!("Running all update_pre for base label: {}", base_label);
        for g in &state_hook_generators {
            trace!("Running update_pre for generator: {:?}", g);
            self.states_mut().update_pre(u, g);
        }
        trace!(
            "Finished running all update_pre for base label: {}",
            base_label
        );

        // Register the subtrees
        let generator = self.generators.get(selected_label).unwrap();
        let (subtrees, compose_constraint) =
            match generator.subtrees(u, &mut self.states_mut(), constraint) {
                Ok(s) => s,
                Err(e) => {
                    return Err(anyhow!(
                        "Failed to generate subtrees for generator {:?}:\n{:?}",
                        selected_label,
                        e
                    ));
                },
            };

        let mut asts = vec![];

        for s in subtrees {
            match s {
                Subtree::Candidates(mut c) => {
                    let idx = u.choose_index(c.candidates.len()).unwrap();
                    asts.push(c.candidates.remove(idx));
                },
                Subtree::Generator(g) => {
                    asts.push(self.generate(u, &g.generator_label, &g.constraints)?);
                },
            }
        }

        let new_node =
            generator.compose(u, &mut self.states_mut(), compose_constraint.clone(), asts)?;

        // Use the original given generator to check if the newly created node follows the constraints
        let result = self.generators.get(&base_label).unwrap().check_ast(
            &self.states(),
            constraint,
            &compose_constraint,
            &new_node,
        );
        trace!(
            "{:?}'s check_ast result on {:?}: {}",
            base_label,
            selected_label,
            result
        );

        // TODO: use reference
        if !result {
            return Err(anyhow!(
                "ASTNode generated by {:?} does not follow the constraints for base label {:?}:\n{:?}",
                selected_label,
                base_label,
                new_node
            ));
        }

        trace!("Running all update_pre for base label: {}", base_label);
        for g in &state_hook_generators {
            trace!("Running update_post for generator: {:?}", g);
            self.states_mut().update_post(u, &new_node, g);
        }
        trace!(
            "Finished running all update_pre for base label: {}",
            base_label
        );

        Ok(new_node)
    }
}
