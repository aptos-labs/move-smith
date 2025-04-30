// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Compile a Move file with different compiler settings.

use crate::{
    cli::{Compile, MoveSmithEnv},
    execution::{
        compile::{CompileExecutor, CompileInput, CompileResult, CompileStatus},
        transactional::V2Setting,
        Executor,
    },
};
use std::fs;

pub fn handle_compile(_env: &MoveSmithEnv, cmd: &Compile) {
    let code = fs::read_to_string(&cmd.file).unwrap();
    println!("Loaded code from file: {:?}", cmd.file);

    let executor = CompileExecutor;
    if cmd.no_v1 {
        println!("V1 compilation skipped.")
    } else {
        let input = CompileInput::new_v1(code.clone());
        let result = executor.execute_one(&input);
        print_result(&input, &result);
    }

    if cmd.no_v2 {
        println!("V2 compilation skipped.")
    } else {
        let input = CompileInput::new_v2(code.clone(), V2Setting::default());
        let result = executor.execute_one(&input);
        print_result(&input, &result);
    }
    println!("Done!")
}

fn print_result(input: &CompileInput, result: &CompileResult) {
    let version = if input.v1 { "v1" } else { "v2" };
    println!("{}", result.log);
    let msg = match result.status {
        CompileStatus::Success => format!(
            "Successfully compiled with {} in {}ms",
            version,
            result.duration.as_millis()
        ),
        CompileStatus::Failure => format!(
            "Failed to compile with {} in {}ms",
            version,
            result.duration.as_millis()
        ),
        CompileStatus::Panic => format!("Panicked during {version} compilation"),
    };
    println!("{msg}");
}
