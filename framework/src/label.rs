use serde::{Deserialize, Deserializer};
use std::{
    fmt,
    hash::{Hash, Hasher},
};

pub trait LabelledGenerator {
    fn label() -> GenLabel;
}

pub trait LabelledSubtree {
    fn label() -> SubtreeLabel;
}

pub trait LabelledState {
    fn label() -> StateLabel;
}

#[derive(Debug, PartialOrd, Ord, Clone)]
pub struct GenLabel {
    pub name: String,
    pub level: GeneratorLevel,
}

impl PartialEq for GenLabel {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
    }
}

impl Eq for GenLabel {}

impl Hash for GenLabel {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.name.hash(state);
    }
}

impl<'de> Deserialize<'de> for GenLabel {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>,
    {
        let s = String::deserialize(deserializer)?;
        Ok(GenLabel {
            name: s,
            level: GeneratorLevel::default(),
        })
    }
}

#[derive(Debug, Default, PartialEq, Eq, PartialOrd, Ord, Clone, Hash)]
pub enum GeneratorLevel {
    #[default]
    Top = 0,
    ModuleMember = 1,
    FunctionBody = 2,
}

impl GenLabel {
    pub fn new(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            level: GeneratorLevel::default(),
        }
    }

    pub fn new_top_level(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            level: GeneratorLevel::Top,
        }
    }

    pub fn new_module_member_level(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            level: GeneratorLevel::ModuleMember,
        }
    }

    pub fn new_func_body_level(s: &str) -> Self {
        GenLabel {
            name: s.to_string(),
            level: GeneratorLevel::FunctionBody,
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
