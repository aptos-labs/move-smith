// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

#![no_main]

use arbitrary::Unstructured;
use libfuzzer_sys::fuzz_target;
use move_smith::{
    config::Config,
    execution::{
        transactional::{
            ExecutionMode, TransactionalExecutor, TransactionalInputBuilder, TransactionalResult,
            V2Setting,
        },
        ExecutionManager,
    },
    selection::RandomNumber,
    CodeGenerator, MoveSmith,
};
use once_cell::sync::Lazy;
use std::{env, path::PathBuf, sync::Mutex};

static CONFIG: Lazy<Config> = Lazy::new(|| {
    let config_path =
        env::var("MOVE_SMITH_CONFIG").unwrap_or_else(|_| "MoveSmith.toml".to_string());
    let config_path = PathBuf::from(config_path);
    let mut config = Config::from_toml_file_or_default(&config_path);
    config.generation.num_inline_funcs = RandomNumber::new(0, 0, 0);
    config
});

static RUNNER: Lazy<Mutex<ExecutionManager<TransactionalResult, TransactionalExecutor>>> =
    Lazy::new(|| {
        Mutex::new(ExecutionManager::<TransactionalResult, TransactionalExecutor>::default())
    });

fuzz_target!(|data: &[u8]| {
    let u = &mut Unstructured::new(data);
    let mut smith = MoveSmith::new(&CONFIG.generation);
    match smith.generate(u) {
        Ok(()) => (),
        Err(_) => return,
    };
    let code = smith.get_compile_unit().emit_code();
    let mut input_builder = TransactionalInputBuilder::new();
    let input = input_builder
        .set_code(&code)
        .add_run(ExecutionMode::V2Only, Some(V2Setting::Optimization))
        .add_run(ExecutionMode::V2Only, Some(V2Setting::NoOptimization))
        .build();

    let bug = RUNNER.lock().unwrap().execute_check_new_bug(&input);
    if bug.unwrap() {
        panic!("Found bug")
    }
});
