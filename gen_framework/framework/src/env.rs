use crate::{
    ast::{ASTNode, Program},
    config::Config,
    curr_scope::CurrScope,
    ids::IDPool,
    label::{GenLabel, Label, Labelled, StateLabel},
    types::TypePool,
};
use arbitrary::Unstructured;
use linkme::distributed_slice;
use log::info;
use std::{any::Any, collections::BTreeMap, fmt::Debug};

#[distributed_slice]
pub static STATES: [fn() -> (StateLabel, StateT, Vec<GenLabel>)];

pub trait State: Any + Debug {
    fn update_pre(&mut self, u: &mut Unstructured, prog: &Program, generator: &GenLabel);
    fn update_post(
        &mut self,
        u: &mut Unstructured,
        prog: &Program,
        new_ast: &ASTNode,
        generator: &GenLabel,
    );

    fn as_any(&self) -> &dyn Any;
    fn as_any_mut(&mut self) -> &mut dyn Any;
}
pub type StateT = Box<dyn State>;

#[derive(Debug)]
pub struct Environment {
    pub states: BTreeMap<StateLabel, StateT>,
    pub registry: BTreeMap<GenLabel, Vec<StateLabel>>,
}

impl Environment {
    pub fn new() -> Self {
        let mut states = BTreeMap::new();
        let mut registry = BTreeMap::new();

        STATES.iter().for_each(|state| {
            let (label, state, generators) = state();
            info!("Registering state: {}", label);
            states.insert(label.clone(), state);

            for generator in generators {
                registry
                    .entry(generator.clone())
                    .or_insert_with(Vec::new)
                    .push(label.clone());
            }
        });

        Environment { states, registry }
    }

    pub fn get_state<T: State + Labelled>(&self) -> Option<&T> {
        if let Label::State(label) = T::label() {
            self.get_state_by_label::<T>(&label)
        } else {
            None
        }
    }

    pub fn get_state_mut<T: State + Labelled>(&mut self) -> Option<&mut T> {
        if let Label::State(label) = T::label() {
            self.get_state_mut_by_label::<T>(&label)
        } else {
            None
        }
    }

    pub fn get_state_by_label<T: State>(&self, label: &StateLabel) -> Option<&T> {
        self.states.get(label)?.as_any().downcast_ref::<T>()
    }

    pub fn get_state_mut_by_label<T: State>(&mut self, label: &StateLabel) -> Option<&mut T> {
        self.states.get_mut(label)?.as_any_mut().downcast_mut::<T>()
    }

    pub fn update_pre(&mut self, u: &mut Unstructured, prog: &Program, generator: &GenLabel) {
        if let Some(states) = self.registry.get(generator) {
            for state in states {
                self.states
                    .get_mut(state)
                    .unwrap()
                    .update_pre(u, prog, generator);
            }
        }
    }

    pub fn update_post(
        &mut self,
        u: &mut Unstructured,
        prog: &Program,
        new_ast: &ASTNode,
        generator: &GenLabel,
    ) {
        if let Some(states) = self.registry.get(generator) {
            for state in states {
                self.states
                    .get_mut(state)
                    .unwrap()
                    .update_post(u, prog, new_ast, generator);
            }
        }
    }

    // Helpers for getting mostly used states
    pub fn config(&mut self) -> &mut Config {
        self.get_state_mut::<Config>().unwrap()
    }

    pub fn id_pool(&mut self) -> &mut IDPool {
        self.get_state_mut::<IDPool>().unwrap()
    }

    pub fn type_pool(&mut self) -> &mut TypePool {
        self.get_state_mut::<TypePool>().unwrap()
    }

    pub fn curr_scope(&mut self) -> &mut CurrScope {
        self.get_state_mut::<CurrScope>().unwrap()
    }
}
