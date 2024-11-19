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
    pub fn insert<T: AnyDebug + Clone, S: AsRef<str>>(&mut self, key: S, value: T) {
        self.map.insert(key.as_ref().to_string(), Rc::new(value));
    }

    /// Get the value of the key if it exists and has the correct type,
    /// otherwise return None
    pub fn get<T: AnyDebug + Clone, S: AsRef<str>>(&self, key: S) -> Option<&T> {
        self.map
            .get(key.as_ref())
            .and_then(|v| v.as_any().downcast_ref())
    }

    /// Check if the key exists and if the value has the correct type
    pub fn check<T: AnyDebug + Clone, S: AsRef<str>>(&self, key: S) -> bool {
        self.get::<T, S>(key).is_some()
    }
}
