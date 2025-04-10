// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Configuration for the MoveSmith fuzzer.

use crate::move_ast::MoveAST;
use arbitrary::Unstructured;
use core::fmt;
use framework::{
    selection::{RandomCounter, RandomNumber},
    GenLabel, LabelledState, Register, State, StateEntry, StateLabel,
};
use serde::Deserialize;
use std::path::Path;

/// The configuration for the MoveSmith fuzzer.
#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    pub generation: GenerationConfig,
}

/// MoveSmith will randomly pick within [0..max_num_XXX] during generation.
#[derive(Clone, Deserialize)]
pub struct GenerationConfig {
    /******** Module Related ********/
    pub num_modules: RandomNumber,
    pub num_functions_in_module: RandomNumber,
    pub num_structs_in_module: RandomNumber,
    pub num_enum_in_module: RandomNumber,

    /******** Struct Related ********/
    pub num_fields_in_struct: RandomNumber,
    /// The maximum total number of fields in all structs that can be composite
    pub total_num_composite_type_in_struct: RandomCounter,
    /// Maximum number of type parameters in a struct definition
    pub num_type_params_in_struct: RandomNumber,

    /******** Enum Related ********/
    pub num_variants_in_enum: RandomNumber,
    pub num_fields_in_enum_variant: RandomNumber,
    /// The maximum total number of fields in all enums that can be composite
    pub total_num_composite_type_in_enum: RandomCounter,
    /// Maximum number of type parameters in an enum definition
    pub num_type_params_in_enum: RandomNumber,

    /******** Function Related ********/
    pub num_stmts_in_sequence: RandomNumber,
    pub num_sequences_in_block: RandomNumber,
    pub num_params_in_func: RandomNumber,

    /// Maximum number of type parameters in a function
    pub num_type_params_in_func: RandomNumber,

    /// The number of functions that can have `inline`
    pub num_inline_funcs: RandomNumber,

    /// Allow recursive calls in the generated code
    pub allow_recursive_calls: bool,

    /******** Expression Related ********/
    /// Maximum depth of nested expression
    pub expr_depth: RandomNumber,

    /// Maximum number of bytes to construct hex or byte string
    pub hex_byte_str_size: RandomNumber,

    /******** Type Related ********/
    /// Maximum depth of nested type instantiation
    pub type_depth: RandomNumber,
    /// Number of elements in a tuple
    pub num_elem_in_tuple: RandomNumber,

    /******** Execution ********/
    pub num_calls_in_script: RandomNumber,

    /// The number of `//# run 0xCAFE::ModuleX::funX` to invoke
    pub num_runs_per_func: RandomNumber,

    /// Timeout in seconds
    pub generation_timeout_sec: usize, // MoveSmith generation timeout
}

impl fmt::Debug for GenerationConfig {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "GenerationConfig {{ ... }}")
    }
}

impl Default for Config {
    /// Load default configuration from MoveSmith.default.toml
    fn default() -> Self {
        let file_content = include_str!("../../../MoveSmith.default.toml");
        toml::from_str(file_content).expect("Cannot parse default config TOML")
    }
}

impl Default for GenerationConfig {
    fn default() -> Self {
        let Config { generation } = Config::default();
        generation
    }
}

impl Config {
    pub fn from_toml_file_or_default(file_path: &Path) -> Self {
        if file_path.exists() {
            Self::from_toml_file(file_path)
        } else {
            Config::default()
        }
    }

    pub fn from_toml_file(file_path: &Path) -> Self {
        let config_str = std::fs::read_to_string(file_path).expect("Cannot read from config file");
        let config: Config = toml::from_str(&config_str).expect("Cannot parse config file");
        config
    }
}

impl LabelledState for GenerationConfig {
    fn label() -> StateLabel {
        StateLabel::new("GenerationConfig")
    }
}

impl Register<StateEntry> for GenerationConfig {
    fn register(&self) -> StateEntry {
        StateEntry {
            label: Self::label(),
            generators: vec![],
        }
    }
}

impl State<MoveAST> for GenerationConfig {
    fn update_pre(&mut self, _u: &mut Unstructured, _generator: &GenLabel) {
        // Do nothing
    }

    fn update_post(&mut self, _u: &mut Unstructured, _new_ast: &MoveAST, _generator: &GenLabel) {
        // Do nothing
    }
}
