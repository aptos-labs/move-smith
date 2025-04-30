// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! The commend line interface for the MoveSmith fuzzer and auxiliary tools.
use crate::{
    cli::{MoveSmithEnv, Raw2move},
    utils::create_move_package,
    MoveSmith,
};
use std::{
    fs,
    io::{stdin, Read},
    path::PathBuf,
    time::Instant,
};

pub fn handle_raw2move(_env: &MoveSmithEnv, cmd: &Raw2move) {
    let bytes = match cmd.stdin {
        true => {
            let mut buffer = vec![];
            stdin().read_to_end(&mut buffer).unwrap();
            buffer
        },
        false => fs::read(cmd.raw_file.clone().unwrap()).unwrap(),
    };

    let start = Instant::now();
    let (_, _, code) = raw2move(&bytes);
    let elapsed = start.elapsed();

    if let Some(save_as) = &cmd.save_as_package {
        let save_as = PathBuf::from(save_as);
        create_move_package(code.clone(), &save_as);
        println!("Generated Move package in {}ms", elapsed.as_millis());
        println!("Saved as package at: {save_as:?}");
    } else {
        println!("{code}");
        println!("// Generated Move code in {}ms", elapsed.as_millis());
    }
}

/// Returns:
/// - bool: success or not
/// - String: log message
/// - String: Move code, empty if failed
pub fn raw2move(bytes: &[u8]) -> (bool, String, String) {
    let msmith = MoveSmith::new();
    let code = match msmith.generate(bytes) {
        Ok(code) => code,
        Err(e) => {
            return (
                false,
                format!("MoveSmith failed to generate code:\n{e:?}"),
                "".to_string(),
            );
        },
    };
    (true, "Parsed raw input successfully".to_string(), code)
}
