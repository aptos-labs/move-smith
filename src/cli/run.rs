// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Execute a Move file or a raw byte file.

use crate::{
    cli::{raw2move::raw2move, MoveSmithEnv, OutputMode, Run},
    execution::{
        transactional::{TransactionalExecutor, TransactionalInput},
        Executor,
    },
};
use std::{fs, path::PathBuf};

pub fn handle_run(env: &MoveSmithEnv, cmd: &Run) {
    let runner = TransactionalExecutor {};
    let setting = env
        .config
        .get_compiler_setting(cmd.use_setting.as_str())
        .unwrap();

    let input = match fs::read_to_string(&cmd.file) {
        Ok(_) => TransactionalInput::new_from_file(PathBuf::from(&cmd.file), &setting),
        Err(_) => {
            println!("Converting: {:?} to Move", cmd.file);
            let bytes = fs::read(&cmd.file).unwrap();
            let (success, log, code) = raw2move(&env.config.generation, &bytes);
            if !success {
                println!("Failed to convert raw bytes to Move code:\n{}", log);
                return;
            }
            TransactionalInput::new_from_str(&code, &setting)
        },
    };
    println!("Loaded code from file: {:?}", cmd.file);
    let result: crate::execution::transactional::TransactionalResult = runner.execute_one(&input);
    match cmd.output {
        OutputMode::Raw => {
            println!("{}", result.log);
            println!("{:?}", result.status);
            println!("Duration: {:?}", result.duration);
        },
        OutputMode::Split => {
            println!("V1 output:");
            println!(
                "{}",
                result.splitted_logs.get(0).unwrap_or(&"empty".to_string())
            );
            println!("\nV2 output:");
            println!(
                "{}",
                result.splitted_logs.get(1).unwrap_or(&"empty".to_string())
            );
            println!("{:?}", result.status);
            println!("Duration: {:?}", result.duration);
        },
        OutputMode::Canonicalized => {
            println!("{}", result);
        },
        OutputMode::None => (),
    }
    // println!(
    //     "Will be ignored: {}",
    //     runner.error_pool.should_skip_result(r)
    // );
    println!("Done!");
}
