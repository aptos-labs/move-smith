// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Configuration for the MoveSmith fuzzer.

use crate::selection::RandomNumber;
use serde::Deserialize;
use std::path::Path;

/// The configuration for the MoveSmith fuzzer.
#[derive(Debug, Clone, Deserialize)]
pub struct Config {
    pub generation: GenerationConfig,
}
/// MoveSmith will randomly pick within [0..max_num_XXX] during generation.
#[derive(Debug, Clone, Deserialize)]
pub struct GenerationConfig {
    /// The number of `//# run 0xCAFE::ModuleX::funX` to invoke
    pub num_runs_per_func: RandomNumber,
    /// The number of functions that can have `inline`
    pub num_inline_funcs: RandomNumber,

    pub num_modules: RandomNumber,
    pub num_functions_in_module: RandomNumber,
    pub num_structs_in_module: RandomNumber,

    pub num_fields_in_struct: RandomNumber,
    /// The maximum total number of fields in all structs that can have
    /// type of another struct
    pub num_fields_of_struct_type: RandomNumber,

    // Includes all kinds of statements
    pub num_stmts_in_func: RandomNumber,
    // Addtionally insert some resource or vector operations
    pub num_additional_operations_in_func: RandomNumber,

    pub num_params_in_func: RandomNumber,

    // This has lowest priority
    // i.e. if the block is a function body
    // max_num_stmts_in_func will override this
    pub num_stmts_in_block: RandomNumber,

    pub num_calls_in_script: RandomNumber,

    // Maximum depth of nested expression
    pub expr_depth: RandomNumber,
    // Maximum depth of nested type instantiation
    pub type_depth: RandomNumber,

    // Maximum number of type parameters in a function
    pub num_type_params_in_func: RandomNumber,
    // Maximum number of type parameters in a struct definition
    pub num_type_params_in_struct: RandomNumber,

    // Timeout in seconds
    pub generation_timeout_sec: usize, // MoveSmith generation timeout

    // Allow recursive calls in the generated code
    pub allow_recursive_calls: bool,

    // Maximum number of bytes to construct hex or byte string
    pub hex_byte_str_size: RandomNumber,
}

impl Default for Config {
    /// Load default configuration from MoveSmith.default.toml
    fn default() -> Self {
        let file_content = include_str!("../MoveSmith.default.toml");
        toml::from_str(file_content).expect("Cannot parse default config TOML")
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
