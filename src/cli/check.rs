// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Checks a corpus of raw input and clusters the errors found.

use crate::{
    cli::{common::get_progress_bar_with_msg, raw2move::raw2move, Check, MoveSmithEnv},
    execution::{
        transactional::{TransactionalExecutor, TransactionalInput},
        ExecutionManager,
    },
};
use core::panic;
use glob::glob;
use indicatif::HumanDuration;
use rayon::prelude::*;
use std::{fs, path::Path, time::Instant};

pub fn handle_check(env: &MoveSmithEnv, cmd: &Check) {
    let corpus_dir = Path::new(&cmd.corpus_dir);
    println!("Checking corpus dir: {:?}", corpus_dir);
    if !corpus_dir.exists() {
        panic!("Corpus dir does not exist");
    }

    let mut all_inputs = vec![];
    let patterns = ["crash*", "oom*", "*.raw"];
    for pattern in &patterns {
        let search_pattern = format!("{}/**/{}", corpus_dir.display(), pattern);
        for entry in glob(&search_pattern).expect("Failed to read glob pattern") {
            match entry {
                Ok(path) => all_inputs.push(path),
                Err(e) => println!("{:?}", e),
            }
        }
    }
    println!("[1/3] Found {} crashing input files", all_inputs.len());

    println!("[2/3] Executing crashing inputs...");
    let mut executor = ExecutionManager::<TransactionalExecutor>::default();
    executor.set_save_input(true);
    let setting = env
        .config
        .get_compiler_setting(env.cli.global_options.use_setting.as_str())
        .unwrap();

    let pb = get_progress_bar_with_msg(all_inputs.len() as u64, "Checking");
    let timer = Instant::now();
    let results: Vec<bool> = all_inputs
        .par_iter()
        .map(|input_file| {
            let bytes = fs::read(input_file).unwrap();
            let (success, _, code) = raw2move(&env.config.generation, &bytes);
            let code = {
                if !success {
                    pb.println(format!(
                        "Failed to convert raw bytes for {}",
                        input_file.display()
                    ));
                    pb.inc(1);
                    return false;
                }
                code
            };
            let move_file = input_file.with_extension("move");
            fs::write(&move_file, &code).unwrap();

            let input = TransactionalInput::new_from_file(move_file.clone(), setting);
            let _ = executor.execute(&input);
            pb.inc(1);
            true
        })
        .collect();
    let num_not_parsed = results.iter().filter(|r| !**r).count();
    pb.finish_and_clear();
    println!("[2/3] {} input files cannot be parsed", num_not_parsed);
    println!(
        "[2/3] Executed {} crashing input files",
        all_inputs.len() - num_not_parsed
    );

    println!(
        "[2/3] Clustered {} runs into {} new errors",
        all_inputs.len(),
        executor.pool.lock().unwrap().len(),
    );

    let to_open = executor.generate_report(&cmd.format, &cmd.output_dir);

    println!("[3/3] Saved report to: {:?}", to_open);
    println!("Done checking in {}", HumanDuration(timer.elapsed()));
}
