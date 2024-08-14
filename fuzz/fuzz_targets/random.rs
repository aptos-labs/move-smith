// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

#![no_main]

use arbitrary::Unstructured;
use libfuzzer_sys::fuzz_target;
use move_smith::{config::Config, runner::Runner, CodeGenerator, MoveSmith};
use once_cell::sync::Lazy;
use rand::{rngs::StdRng, Rng, SeedableRng};
use std::{env, path::PathBuf, sync::Mutex};

static CONFIG: Lazy<Config> = Lazy::new(|| {
    let config_path =
        env::var("MOVE_SMITH_CONFIG").unwrap_or_else(|_| "MoveSmith.toml".to_string());
    let config_path = PathBuf::from(config_path);
    Config::from_toml_file_or_default(&config_path)
});

static RUNNER: Lazy<Mutex<Runner>> =
    Lazy::new(|| Mutex::new(Runner::new_with_known_errors(&CONFIG.fuzz, false)));

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

        let mut smith = MoveSmith::new(&CONFIG.generation);
        let u = &mut Unstructured::new(&buffer);
        match smith.generate(u) {
            Ok(()) => break smith.get_compile_unit().emit_code(),
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

    let results = RUNNER.lock().unwrap().run_transactional_test(&code);
    RUNNER.lock().unwrap().keep_and_check_results(&results);
});
