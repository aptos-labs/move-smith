// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Utility functions for MoveSmith.

#[cfg(feature = "git_deps")]
use move_model::metadata::{CompilerVersion, LanguageVersion};
#[cfg(feature = "legacy_deps")]
use move_model_legacy::metadata::{CompilerVersion, LanguageVersion};
#[cfg(feature = "local_deps")]
use move_model_local::metadata::{CompilerVersion, LanguageVersion};
#[cfg(feature = "git_deps")]
use move_package::BuildConfig;
#[cfg(feature = "legacy_deps")]
use move_package_legacy::BuildConfig;
#[cfg(feature = "local_deps")]
use move_package_local::BuildConfig;
use rand::{rngs::StdRng, Rng, SeedableRng};
use std::{
    fs,
    fs::File,
    io::Write,
    path::{Path, PathBuf},
};
use tempfile::{tempdir, TempDir};

const MOVE_TOML_TEMPLATE: &str = r#"[package]
name = "test"
version = "0.0.0"

[dependencies]
AptosFramework = { local = "$PATH" }
"#;

/// Get random bytes
pub fn get_random_bytes(seed: u64, length: usize) -> Vec<u8> {
    let mut rng = StdRng::seed_from_u64(seed);
    let mut buffer = vec![0u8; length];
    rng.fill(&mut buffer[..]);
    buffer
}

/// Create a temporary Move file with the given code.
// TODO: if on Linux, we can create in-memory file to reduce I/O
pub fn create_tmp_move_file(code: &str, name_hint: Option<&str>) -> (PathBuf, TempDir) {
    let dir: TempDir = tempdir().unwrap();
    let name = name_hint.unwrap_or("temp.move");
    let file_path = dir.path().join(name);
    {
        let mut file = File::create(&file_path).unwrap();
        writeln!(file, "{code}").unwrap();
    }
    (file_path, dir)
}

pub fn get_move_smith_path() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
}

// TODO: get path from cli args
pub fn get_aptos_framework_path() -> String {
    let crate_dir = get_move_smith_path();
    let relative_path = crate_dir.join("../../aptos-core/aptos-move/framework/aptos-framework/");
    let absolute_path = relative_path.canonicalize().unwrap();
    absolute_path.to_str().unwrap().to_string()
}

/// Create a Move package with the given code and minimal Move.toml.
pub fn create_move_package(code: String, output_dir: &Path) {
    let source_dir = output_dir.join("sources");
    fs::create_dir_all(&source_dir).expect("Failed to create package directory");

    let move_toml_path = output_dir.join("Move.toml");
    let aptos_framework_path = get_aptos_framework_path();
    let move_toml_content = MOVE_TOML_TEMPLATE.replace("$PATH", &aptos_framework_path);
    fs::write(move_toml_path, move_toml_content).expect("Failed to write Move.toml");

    let move_path = source_dir.join("MoveSmith.move");
    fs::write(move_path, code).expect("Failed to write the Move file");
}

/// Create the build configuration for compiler V1
pub fn create_compiler_config_v1() -> BuildConfig {
    let mut config = BuildConfig::default();
    config.compiler_config.compiler_version = Some(CompilerVersion::V1);
    config
}

/// Create the build configuration for compiler V2
pub fn create_compiler_config_v2() -> BuildConfig {
    let mut config = BuildConfig::default();
    config.compiler_config.compiler_version = Some(CompilerVersion::V2_1);
    config.compiler_config.language_version = Some(LanguageVersion::V2_1);
    config
}

/// Create a temporary Move package with the given code.
pub fn create_tmp_move_package(code: String) -> (PathBuf, TempDir) {
    let dir: TempDir = tempdir().unwrap();
    let output_dir = dir.path().to_path_buf();
    create_move_package(code, &output_dir);
    (output_dir, dir)
}
