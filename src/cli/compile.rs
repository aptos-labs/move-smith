// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Compile a Move file with different compiler settings.

use crate::{
    cli::{Compile, MoveSmithEnv},
    execution::transactional::V2Setting,
    utils::compile_move_code,
};
use std::{fs, time::Instant};

pub fn handle_compile(_env: &MoveSmithEnv, cmd: &Compile) {
    let code = fs::read_to_string(&cmd.file).unwrap();
    println!("Loaded code from file: {:?}", cmd.file);

    if cmd.no_v1 {
        println!("V1 compilation skipped.")
    } else {
        let comp_log = compile_move_code_with_setting(&code, false);
        println!("{}", comp_log);
    }

    if cmd.no_v2 {
        println!("V2 compilation skipped.")
    } else {
        let comp_log = compile_move_code_with_setting(&code, true);
        println!("{}", comp_log);
    }
    println!("Done!")
}

fn compile_move_code_with_setting(code: &str, v2: bool) -> String {
    let version = if v2 { "v2" } else { "v1" };
    set_v2_experiments(&V2Setting::default());
    let timer = Instant::now();
    let result = std::panic::catch_unwind(|| compile_move_code(code.to_string(), !v2, v2));

    let duration = timer.elapsed();

    match result {
        Ok(true) => format!(
            "Successfully compiled with {} in {}ms",
            version,
            duration.as_millis()
        ),
        Ok(false) => format!(
            "Failed to compile with {} in {}ms",
            version,
            duration.as_millis(),
        ),
        Err(e) => format!("Paniced during {} compilation:\n{:?}", version, e),
    }
}

pub fn set_v2_experiments(setting: &V2Setting) {
    let mut feats = vec![];
    let experiments = setting.to_expriments();
    for (exp, enabled) in experiments.iter() {
        feats.push(format!("{}={}", exp, if *enabled { "on" } else { "off" }));
    }
    let feats_value = feats.join(",");
    std::env::set_var("MVC_EXP", feats_value);
}
