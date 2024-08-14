// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

#[macro_use]
extern crate afl;

use arbitrary::Unstructured;
use move_smith::{config::Config, runner::Runner, CodeGenerator, MoveSmith};
use once_cell::sync::Lazy;
use std::{env, path::PathBuf, sync::Mutex};

static CONFIG: Lazy<Config> = Lazy::new(|| {
    let config_path =
        env::var("MOVE_SMITH_CONFIG").unwrap_or_else(|_| "MoveSmith.toml".to_string());
    let config_path = PathBuf::from(config_path);
    Config::from_toml_file_or_default(&config_path)
});

static RUNNER: Lazy<Mutex<Runner>> =
    Lazy::new(|| Mutex::new(Runner::new_with_known_errors(&CONFIG.fuzz, false)));

fn main() {
    fuzz!(|data: &[u8]| {
        let u = &mut Unstructured::new(data);
        let mut smith = MoveSmith::new(&CONFIG.generation);
        match smith.generate(u) {
            Ok(()) => (),
            Err(_) => return,
        };
        let code = smith.get_compile_unit().emit_code();
        let results = RUNNER.lock().unwrap().run_transactional_test(&code);
        RUNNER.lock().unwrap().keep_and_check_results(&results);
    });
}
