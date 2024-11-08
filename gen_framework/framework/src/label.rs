use std::{collections::BTreeMap, fmt};

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone)]
pub enum Label {
    Gen(GenLabel),
    Subtree(SubtreeLabel),
    State(StateLabel),
}

pub trait Labelled {
    fn label() -> Label;
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone)]
pub struct GenLabel {
    pub name: String,
    /// Whether this label represents a type definition e.g. struct, enum
    pub type_def: bool,
    pub func_def: bool,
    pub top_level: bool,
}

impl GenLabel {
    pub fn new(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            type_def: false,
            func_def: false,
            top_level: false,
        }
    }

    pub fn new_top_level(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            type_def: false,
            func_def: false,
            top_level: true,
        }
    }

    pub fn new_type_def(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            type_def: true,
            func_def: false,
            top_level: false,
        }
    }

    pub fn new_func_def(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            type_def: false,
            func_def: true,
            top_level: false,
        }
    }
}

impl fmt::Display for GenLabel {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.name)
    }
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone)]
pub struct SubtreeLabel(pub String);

impl SubtreeLabel {
    pub fn new(s: &str) -> Self {
        SubtreeLabel(s.to_string())
    }
}

impl fmt::Display for SubtreeLabel {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone)]
pub struct StateLabel(pub String);

impl StateLabel {
    pub fn new(s: &str) -> Self {
        StateLabel(s.to_string())
    }
}

impl fmt::Display for StateLabel {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.0)
    }
}
