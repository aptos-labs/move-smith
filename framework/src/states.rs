use crate::{
    anydebug::AnyDebug,
    label::{GenLabel, LabelledState, StateLabel},
    ASTNode, Register,
};
use arbitrary::Unstructured;
use log::info;
use std::{collections::BTreeMap, fmt::Debug};

pub struct StateEntry {
    pub label: StateLabel,
    pub generators: Vec<GenLabel>,
}

pub trait State<A: ASTNode>: AnyDebug + Register<StateEntry> {
    fn update_pre(&mut self, u: &mut Unstructured, generator: &GenLabel);
    fn update_post(&mut self, u: &mut Unstructured, new_ast: &A, generator: &GenLabel);
}
pub type StateT<A> = Box<dyn State<A>>;

#[derive(Debug)]
pub struct StatePool<A: ASTNode> {
    pub states: BTreeMap<StateLabel, StateT<A>>,
    pub registry: BTreeMap<GenLabel, Vec<StateLabel>>,
}

impl<A> StatePool<A>
where
    A: ASTNode + 'static,
{
    pub fn empty() -> Self {
        Self {
            states: BTreeMap::new(),
            registry: BTreeMap::new(),
        }
    }

    pub fn register_state<T: State<A> + LabelledState>(&mut self, state: T) {
        let entry = state.register();
        info!("Registering state: {}", entry.label);
        self.states.insert(entry.label.clone(), Box::new(state));

        for generator in entry.generators {
            self.registry
                .entry(generator.clone())
                .or_default()
                .push(entry.label.clone());
        }
    }

    /// Same as `get` but panics if the state is not found.
    pub fn get_fail<T: State<A> + LabelledState>(&self) -> &T {
        self.get::<T>().unwrap()
    }

    /// Same as `get_mut` but panics if the state is not found.
    pub fn get_mut_fail<T: State<A> + LabelledState>(&mut self) -> &mut T {
        self.get_mut::<T>().unwrap()
    }

    pub fn get<T: State<A> + LabelledState>(&self) -> Option<&T> {
        self.get_by_label::<T>(&T::label())
    }

    pub fn get_mut<T: State<A> + LabelledState>(&mut self) -> Option<&mut T> {
        self.get_mut_by_label::<T>(&T::label())
    }

    pub fn get_by_label<T: State<A>>(&self, label: &StateLabel) -> Option<&T> {
        (**self.states.get(label)?).as_any().downcast_ref::<T>()
    }

    pub fn get_mut_by_label<T: State<A>>(&mut self, label: &StateLabel) -> Option<&mut T> {
        (**self.states.get_mut(label)?)
            .as_any_mut()
            .downcast_mut::<T>()
    }

    pub fn update_pre(&mut self, u: &mut Unstructured, generator: &GenLabel) {
        if let Some(states) = self.registry.get(generator) {
            for state in states {
                self.states.get_mut(state).unwrap().update_pre(u, generator);
            }
        }
    }

    pub fn update_post(&mut self, u: &mut Unstructured, new_node: &A, generator: &GenLabel) {
        if let Some(states) = self.registry.get(generator) {
            for state in states {
                self.states
                    .get_mut(state)
                    .unwrap()
                    .update_post(u, new_node, generator);
            }
        }
    }
}
