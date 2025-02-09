use std::fmt;

pub trait LabelledGenerator {
    fn label() -> GenLabel;
}

pub trait LabelledSubtree {
    fn label() -> SubtreeLabel;
}

pub trait LabelledState {
    fn label() -> StateLabel;
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone)]
pub struct GenLabel {
    pub name: String,
    pub level: GeneratorLevel,
}

#[derive(Debug, Default, PartialEq, Eq, PartialOrd, Ord, Clone)]
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
