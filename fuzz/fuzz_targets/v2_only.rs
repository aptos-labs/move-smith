// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

#![no_main]

use libfuzzer_sys::fuzz_target;
use msmith::{
    execution::{
        transactional::{
            CommonRunConfig, TransactionalExecutor, TransactionalInputBuilder, TransactionalResult,
        },
        ExecutionManager,
    },
    MoveSmith,
};
use once_cell::sync::Lazy;
use std::{env, fs::OpenOptions, io::Write, sync::Mutex, time::Instant};

static FILE_MUTEX: Lazy<Mutex<()>> = Lazy::new(|| Mutex::new(()));

static RUNNER: Lazy<Mutex<ExecutionManager<TransactionalResult, TransactionalExecutor>>> =
    Lazy::new(|| {
        Mutex::new(ExecutionManager::<TransactionalResult, TransactionalExecutor>::default())
    });

fuzz_target!(|data: &[u8]| {
    let smith = MoveSmith::new();
    let do_profile = match env::var("MOVE_SMITH_PROFILING") {
        Ok(v) => v == "1",
        Err(_) => false,
    };
    if do_profile {
        let mut profile_s = String::new();

        let start = Instant::now();
        let code = match smith.generate(data) {
            Ok(code) => code,
            Err(_) => return,
        };
        let elapsed = start.elapsed();
        profile_s.push_str(&format!(
            "move-smith-profile::time::generation::{}ms\n",
            elapsed.as_millis()
        ));

        let start = Instant::now();

        let mut input_builder = TransactionalInputBuilder::new();
        let input = input_builder
            .set_code(&code)
            .with_common_runs(&CommonRunConfig::V2Only)
            .build();
        let bug = RUNNER.lock().unwrap().execute_check_new_bug(&input);

        let elapsed = start.elapsed();

        profile_s.push_str(&format!(
            "move-smith-profile::time::transactional::{}ms\n",
            elapsed.as_millis()
        ));

        let status = match &bug {
            Ok(_) => "success",
            Err(_) => "error",
        };
        profile_s.push_str(&format!("move-smith-profile::status::{}\n", status));

        let _lock = FILE_MUTEX.lock().unwrap();
        let mut file = OpenOptions::new()
            .create(true)
            .append(true)
            .open("move-smith-profile.txt")
            .unwrap();
        file.write_all(profile_s.as_bytes()).unwrap();
        if bug.unwrap() {
            panic!("Found bug")
        }
    } else {
        let code = match smith.generate(data) {
            Ok(code) => code,
            Err(_) => return,
        };

        let mut input_builder = TransactionalInputBuilder::new();
        let input = input_builder
            .set_code(&code)
            .with_common_runs(&CommonRunConfig::V2Only)
            .build();

        let bug = RUNNER.lock().unwrap().execute_check_new_bug(&input);
        if bug.unwrap() {
            panic!("Found bug")
        }
    }
});
