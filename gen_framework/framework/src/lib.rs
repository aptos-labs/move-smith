pub mod anydebug;
pub mod constraints;
pub mod framework;
pub mod generator;
pub mod label;
pub mod macros;
pub mod register;
pub mod selection;
pub mod states;

use std::fmt::Debug;

pub trait ASTNode: Clone + Debug {}

pub use constraints::{AnyConstraint, Constraint};
pub use framework::{Framework, FrameworkBuilder};
pub use generator::{Generator, GeneratorEntry, GeneratorPool, GeneratorT, Subtree};
pub use label::{GenLabel, Label, Labelled, StateLabel};
pub use register::Register;
pub use states::{State, StateEntry, StatePool, StateT};
