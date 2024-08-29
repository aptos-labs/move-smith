// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! The commend line interface for the MoveSmith fuzzer and auxiliary tools.
use crate::{
    cli::{MoveSmithEnv, Raw2move},
    config::GenerationConfig,
    utils::create_move_package,
    CodeGenerator, MoveSmith,
};
use arbitrary::Unstructured;
use std::{
    fs,
    io::{stdin, Read},
    path::PathBuf,
    time::Instant,
};

pub fn handle_raw2move(env: &MoveSmithEnv, cmd: &Raw2move) {
    let bytes = match cmd.stdin {
        true => {
            let mut buffer = vec![];
            stdin().read_to_end(&mut buffer).unwrap();
            buffer
        },
        false => fs::read(cmd.raw_file.clone().unwrap()).unwrap(),
    };

    let start = Instant::now();
    let (_, _, code) = raw2move(&env.config.generation, &bytes);
    let elapsed = start.elapsed();

    if let Some(save_as) = &cmd.save_as_package {
        let save_as = PathBuf::from(save_as);
        create_move_package(code.clone(), &save_as);
        println!("Generated Move package in {}ms", elapsed.as_millis());
        println!("Saved as package at: {:?}", save_as);
    } else {
        println!("{}", code);
        println!("// Generated Move code in {}ms", elapsed.as_millis());
    }
}

/// Returns:
/// - bool: success or not
/// - String: log message
/// - String: Move code, empty if failed
pub fn raw2move(conf: &GenerationConfig, bytes: &[u8]) -> (bool, String, String) {
    let mut u = Unstructured::new(bytes);

    let mut smith = MoveSmith::new(conf);
    match smith.generate(&mut u) {
        Ok(_) => (),
        Err(e) => {
            return (
                false,
                format!("MoveSmith failed to generate code:\n{:?}", e),
                "".to_string(),
            );
        },
    };

    let code = smith.get_compile_unit().emit_code();
    (true, "Parsed raw input successfully".to_string(), code)
}
