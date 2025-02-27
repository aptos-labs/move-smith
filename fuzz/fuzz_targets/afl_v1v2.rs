// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

#[macro_use]
extern crate afl;

use msmith::{
    execution::{
        transactional::{TransactionalExecutor, TransactionalInputBuilder, TransactionalResult},
        ExecutionManager,
    },
    MoveSmith,
};
use once_cell::sync::Lazy;
use std::sync::Mutex;

static RUNNER: Lazy<Mutex<ExecutionManager<TransactionalResult, TransactionalExecutor>>> =
    Lazy::new(|| {
        Mutex::new(ExecutionManager::<TransactionalResult, TransactionalExecutor>::default())
    });

fn main() {
    fuzz!(|data: &[u8]| {
        let smith = MoveSmith::new();
        let code = match smith.generate(data) {
            Ok(code) => code,
            Err(_) => return,
        };
        let mut input_builder = TransactionalInputBuilder::new();
        let input = input_builder.set_code(&code).with_default_run().build();
        let bug = RUNNER.lock().unwrap().execute_check_new_bug(&input);
        if bug.unwrap() {
            panic!("Found bug")
        }
    });
}
