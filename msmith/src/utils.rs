// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Utility functions for MoveSmith.

use log::{error, info};
#[cfg(feature = "git_deps")]
use move_model::metadata::{CompilerVersion, LanguageVersion};
#[cfg(feature = "local_deps")]
use move_model_local::metadata::{CompilerVersion, LanguageVersion};
#[cfg(feature = "git_deps")]
use move_package::BuildConfig;
#[cfg(feature = "local_deps")]
use move_package_local::BuildConfig;
use rand::{rngs::StdRng, Rng, SeedableRng};
use std::{
    fs,
    fs::File,
    io::{stderr, Write},
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
        writeln!(file, "{}", code).unwrap();
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

/// Compile the Move package at the given path using the given compiler config.
pub fn compile_with_config<W: Write>(
    package_path: &Path,
    config: BuildConfig,
    name: &str,
    writer: Option<&mut W>,
) -> bool {
    let result = match writer {
        Some(writer) => config.compile_package_no_exit(package_path, vec![], writer),
        None => config.compile_package_no_exit(package_path, vec![], &mut stderr()),
    };
    match result {
        Ok(_) => {
            info!("Successfully compiled the package with compiler {}", name);
            true
        },
        Err(err) => {
            error!(
                "Failed to compile the package with compiler {}: {:?}",
                name, err
            );
            false
        },
    }
}

/// Create a temporary Move package with the given code.
pub fn create_tmp_move_package(code: String) -> (PathBuf, TempDir) {
    let dir: TempDir = tempdir().unwrap();
    let output_dir = dir.path().to_path_buf();
    create_move_package(code, &output_dir);
    (output_dir, dir)
}

/// Create a temporary package and compiler the given Move code.
/// V1 and V2 can be enabled/disabled separately.
pub fn compile_move_code<W: Write>(
    code: String,
    v1: bool,
    v2: bool,
    writer: Option<&mut W>,
) -> bool {
    if v1 == v2 {
        panic!("V1 and V2 cannot be enabled/disabled at the same time");
    }

    let (package_path, dir) = create_tmp_move_package(code.clone());
    info!("created temp move package at {:?}", package_path);

    let result = if v1 {
        let config = create_compiler_config_v1();
        let result = compile_with_config(&package_path, config, "v1", writer);
        info!("Done compiling with V1");
        result
    } else {
        let config = create_compiler_config_v2();
        let result = compile_with_config(&package_path, config, "v2", writer);
        info!("Done compiling with V2");
        result
    };
    dir.close().unwrap();
    result
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::panic;

    const MOVE_CODE: &str = r#" //# publish
module 0xCAFE::Module1 {
    struct Struct3 has drop, copy {
        var32: u16,
        var33: u32,
        var34: u8,
        var35: u32,
        var36: u32,
    }

    public fun function6(): Struct3 {
        let var44: u16 =  21859u16;
        let var45: u32 =  1399722001u32;
        Struct3 {
            var32: var44,
            var33: var45,
            var34: 154u8,
            var35: var45,
            var36: var45,
        }
    }
}"#;

    const MOVE_CODE_V1_ERR: &str = r#" //# publish
module 0xCAFE::Module0 {
    public fun function0<T0: drop, T1: drop + store, T2: copy + drop + store> (var0: T2): T2 {
        if ((var0 == if (true)  { var0 } else { var0 }))  {
        } else {
            var0 = var0;
        };
        var0
    }
}"#;

    #[test]
    fn test_compile() {
        let code = MOVE_CODE.to_string();
        let result = compile_move_code(code, true, true);
        assert!(result);
    }

    #[test]
    fn test_compile_err() {
        let code = MOVE_CODE_V1_ERR.to_string();

        // Should not compile with V1
        let result = panic::catch_unwind(|| compile_move_code(code.clone(), true, true));
        assert!(result.is_err());
    }
}
