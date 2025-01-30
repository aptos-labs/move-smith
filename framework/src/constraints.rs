use crate::anydebug::AnyDebug;
use std::{collections::BTreeMap, fmt::Debug, rc::Rc};

pub trait Constraint: Clone + Debug {}

#[derive(Debug)]
pub struct AnyConstraint {
    map: BTreeMap<String, Rc<dyn AnyDebug>>,
}

impl Clone for AnyConstraint {
    fn clone(&self) -> Self {
        let mut new_map = BTreeMap::new();
        for (k, v) in &self.map {
            new_map.insert(k.clone(), Rc::clone(v));
        }
        Self { map: new_map }
    }
}

impl Constraint for AnyConstraint {}

impl AnyConstraint {
    pub fn new() -> Self {
        Self {
            map: BTreeMap::new(),
        }
    }

    /// Insert a key-value pair into the constraint
    pub fn insert<T: AnyDebug + Clone>(&mut self, key: &str, value: T) {
        self.map.insert(key.to_string(), Rc::new(value));
    }

    /// Get the value of the key if it exists and has the correct type,
    /// otherwise return None
    pub fn get<T: AnyDebug + Clone>(&self, key: &str) -> Option<&T> {
        self.map
            .get(key)
            .and_then(|v| (**v).as_any().downcast_ref())
    }

    /// Check if the key exists and if the value has the correct type
    pub fn check<T: AnyDebug + Clone>(&self, key: &str) -> bool {
        self.get::<T>(key).is_some()
    }
}
