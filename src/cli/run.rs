// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Execute a Move file or a raw byte file.

use crate::{
    cli::{raw2move::raw2move, MoveSmithEnv, OutputMode, Run},
    execution::{
        transactional::{
            result::ResultStatus, TransactionalExecutor, TransactionalInputBuilder,
            TransactionalResult,
        },
        ExecutionManager,
    },
};
use std::{fs, path::PathBuf};

pub fn handle_run(env: &MoveSmithEnv, cmd: &Run) {
    let executor = ExecutionManager::<TransactionalResult, TransactionalExecutor>::default();

    let mut input_builder = TransactionalInputBuilder::new();
    match fs::read_to_string(&cmd.file) {
        Ok(_) => input_builder.load_code_from_file(PathBuf::from(&cmd.file)),
        Err(_) => {
            println!("Converting: {:?} to Move", cmd.file);
            let bytes = fs::read(&cmd.file).unwrap();
            let (success, log, code) = raw2move(&env.config.generation, &bytes);
            if !success {
                println!("Failed to convert raw bytes to Move code:\n{}", log);
                return;
            }
            input_builder.set_code(&code)
        },
    };
    match cmd.run_all {
        true => input_builder.with_all_runs(),
        false => input_builder.with_default_run(),
    };
    let input = input_builder.build();

    println!("Loaded code from file: {:?}", cmd.file);
    let result = executor.execute(&input);
    let result = match result {
        Ok(result) => result,
        Err(e) => {
            println!("{:?}", e);
            return;
        },
    };
    match cmd.output {
        OutputMode::Raw => {
            println!("{}", result.log);
            println!("{:?}", result.status);
            println!("Duration: {:?}", result.duration);
        },
        OutputMode::Split => {
            if matches!(result.status, ResultStatus::Panic) {
                println!("{}", result.log);
            } else {
                println!("V1 output:");
                println!(
                    "{}",
                    result.splitted_logs.first().unwrap_or(&"empty".to_string())
                );
                println!("\nV2 output:");
                println!(
                    "{}",
                    result.splitted_logs.get(1).unwrap_or(&"empty".to_string())
                );
            }
            println!("{:?}", result.status);
            println!("Duration: {:?}", result.duration);
        },
        OutputMode::Canonicalized => {
            println!("{}", result);
        },
        OutputMode::None => (),
    }
    println!("Done!");
}
