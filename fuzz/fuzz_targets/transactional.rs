// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

#![no_main]

use arbitrary::Unstructured;
use libfuzzer_sys::fuzz_target;
use move_smith::{config::Config, runner::Runner, CodeGenerator, MoveSmith};
use once_cell::sync::Lazy;
use std::{env, fs::OpenOptions, io::Write, path::PathBuf, sync::Mutex, time::Instant};

static FILE_MUTEX: Lazy<Mutex<()>> = Lazy::new(|| Mutex::new(()));
static CONFIG: Lazy<Config> = Lazy::new(|| {
    let config_path =
        env::var("MOVE_SMITH_CONFIG").unwrap_or_else(|_| "MoveSmith.toml".to_string());
    let config_path = PathBuf::from(config_path);
    Config::from_toml_file_or_default(&config_path)
});

static RUNNER: Lazy<Mutex<Runner>> =
    Lazy::new(|| Mutex::new(Runner::new_with_known_errors(&CONFIG.fuzz, false)));

fuzz_target!(|data: &[u8]| {
    let u = &mut Unstructured::new(data);
    let mut smith = MoveSmith::new(&CONFIG.generation);
    let do_profile = match env::var("MOVE_SMITH_PROFILING") {
        Ok(v) => v == "1",
        Err(_) => false,
    };
    if do_profile {
        let mut profile_s = String::new();

        let start = Instant::now();
        match smith.generate(u) {
            Ok(()) => (),
            Err(_) => return,
        };
        let elapsed = start.elapsed();
        profile_s.push_str(&format!(
            "move-smith-profile::time::generation::{}ms\n",
            elapsed.as_millis()
        ));

        let code = smith.get_compile_unit().emit_code();
        let start = Instant::now();
        let results = RUNNER.lock().unwrap().run_transactional_test(&code);
        let elapsed = start.elapsed();

        profile_s.push_str(&format!(
            "move-smith-profile::time::transactional::{}ms\n",
            elapsed.as_millis()
        ));

        for r in results.iter() {
            let status = match r.result {
                Ok(_) => "success",
                Err(_) => "error",
            };
            profile_s.push_str(&format!("move-smith-profile::status::{}\n", status));
        }

        let _lock = FILE_MUTEX.lock().unwrap();
        let mut file = OpenOptions::new()
            .create(true)
            .append(true)
            .open("move-smith-profile.txt")
            .unwrap();
        file.write_all(profile_s.as_bytes()).unwrap();

        RUNNER.lock().unwrap().keep_and_check_results(&results);
    } else {
        match smith.generate(u) {
            Ok(()) => (),
            Err(_) => return,
        };
        let code = smith.get_compile_unit().emit_code();
        let results = RUNNER.lock().unwrap().run_transactional_test(&code);
        RUNNER.lock().unwrap().keep_and_check_results(&results);
    }
});
