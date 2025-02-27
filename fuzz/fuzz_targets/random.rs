// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

#![no_main]

use libfuzzer_sys::fuzz_target;
use msmith::{
    execution::{
        transactional::{TransactionalExecutor, TransactionalInputBuilder, TransactionalResult},
        ExecutionManager,
    },
    MoveSmith,
};
use once_cell::sync::Lazy;
use rand::{rngs::StdRng, Rng, SeedableRng};
use std::sync::Mutex;

static RUNNER: Lazy<Mutex<ExecutionManager<TransactionalResult, TransactionalExecutor>>> =
    Lazy::new(|| {
        Mutex::new(ExecutionManager::<TransactionalResult, TransactionalExecutor>::default())
    });

const INITIAL_BUFFER_SIZE: usize = 1024 * 4;
const MAX_BUFFER_SIZE: usize = 1024 * 1024;

fuzz_target!(|data: &[u8]| {
    if data.len() < 8 {
        return;
    }

    let mut seed = [0u8; 8];
    seed.copy_from_slice(&data[0..8]);
    let mut rng = StdRng::seed_from_u64(u64::from_be_bytes(seed));

    let mut buffer_size = INITIAL_BUFFER_SIZE;
    let mut buffer = vec![];

    let code = loop {
        if buffer_size > buffer.len() {
            let diff = buffer_size - buffer.len();
            let mut new_buffer = vec![0u8; diff];
            rng.fill(&mut new_buffer[..]);
            buffer.extend(new_buffer);
        }

        let smith = MoveSmith::new();
        match smith.generate(data) {
            Ok(code) => break code,
            Err(_) => {
                if buffer_size >= MAX_BUFFER_SIZE {
                    panic!(
                        "Failed to generate a module with {} bytes input",
                        buffer_size
                    );
                }
            },
        };
        buffer_size *= 2;
    };

    let mut input_builder = TransactionalInputBuilder::new();
    let input = input_builder.set_code(&code).with_default_run().build();

    let bug = RUNNER.lock().unwrap().execute_check_new_bug(&input);
    if bug.unwrap() {
        panic!("Found bug")
    }
});
