// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Checks a corpus of raw input and clusters the errors found.

use crate::{
    cli::{common::get_progress_bar_with_msg, raw2move::raw2move, Check, MoveSmithEnv},
    execution::{
        transactional::{TransactionalExecutor, TransactionalInput, TransactionalResult},
        ExecutionManager,
    },
};
use core::panic;
use glob::glob;
use indicatif::HumanDuration;
use rand::{seq::SliceRandom, thread_rng};
use rayon::prelude::*;
use std::{
    fs,
    path::{Path, PathBuf},
    sync::Mutex,
    time::Instant,
};

pub fn handle_check(env: &MoveSmithEnv, cmd: &Check) {
    let timer = Instant::now();
    let corpus_dir = Path::new(&cmd.corpus_dir);
    println!("Checking corpus dir: {:?}", corpus_dir);
    if !corpus_dir.exists() {
        panic!("Corpus dir does not exist");
    }

    let mut all_inputs = vec![];
    let patterns = ["crash*", "oom*", "*.raw"];
    let ignore_patterns = [".move", ".output", ".error"];
    for pattern in &patterns {
        let search_pattern = format!("{}/**/{}", corpus_dir.display(), pattern);
        for entry in glob(&search_pattern).expect("Failed to read glob pattern") {
            match entry {
                Ok(path) => {
                    if ignore_patterns
                        .iter()
                        .all(|p| !path.as_os_str().to_str().unwrap().ends_with(p))
                    {
                        all_inputs.push(path);
                    }
                },
                Err(e) => println!("{:?}", e),
            }
        }
    }
    println!("[1/4] Found {} crashing input files", all_inputs.len());

    let num_parse = Mutex::new(0usize);
    let num_parse_err = Mutex::new(0usize);

    println!("[2/4] Getting Move files...");
    let pb = get_progress_bar_with_msg(all_inputs.len() as u64, "Generating");
    let all_moves: Vec<PathBuf> = all_inputs
        .par_iter()
        .filter_map(|input_file| {
            let move_file = input_file.with_extension("move");
            if cmd.regenerate || !move_file.exists() {
                let bytes = fs::read(input_file).unwrap();
                let (success, err_log, code) = raw2move(&env.config.generation, &bytes);
                pb.inc(1);
                match success {
                    true => {
                        *num_parse.lock().unwrap() += 1;
                        fs::write(&move_file, &code).unwrap();
                        Some(move_file)
                    },
                    false => {
                        pb.println(format!(
                            "Failed to convert raw bytes for {}",
                            input_file.display()
                        ));
                        *num_parse_err.lock().unwrap() += 1;
                        let error_file = input_file.with_extension("error");
                        fs::write(&error_file, err_log).unwrap();
                        None
                    },
                }
            } else {
                Some(move_file)
            }
        })
        .collect();

    pb.finish_and_clear();

    println!("[2/4] Parsed {} raw inputs", num_parse.lock().unwrap(),);
    println!(
        "[2/4] {} input files cannot be parsed due to errors",
        num_parse_err.lock().unwrap()
    );
    println!(
        "[2/4] {} Move files loaded/generated in {}",
        all_moves.len(),
        HumanDuration(timer.elapsed())
    );

    println!("[3/4] Loading existing results...");
    let pb = get_progress_bar_with_msg(all_moves.len() as u64, "Loading");
    let mut executor = ExecutionManager::<TransactionalResult, TransactionalExecutor>::default();
    executor.set_save_input(true);
    let setting = env
        .config
        .get_compiler_setting(env.cli.global_options.use_setting.as_str())
        .unwrap();

    let mut to_execute: Vec<(PathBuf, TransactionalInput)> = all_moves
        .par_iter()
        .filter_map(|move_file| {
            let output_file = move_file.with_extension("output");
            let input = TransactionalInput::new_from_file(move_file.clone(), setting);
            pb.inc(1);
            if cmd.rerun || !output_file.exists() {
                Some((move_file.clone(), input))
            } else {
                let result = executor.load_result_from_disk(&output_file);
                executor.add_result(&result, Some(&input));
                None
            }
        })
        .collect();
    pb.finish_and_clear();
    to_execute.shuffle(&mut thread_rng());

    println!("[3/4] {} Move files to (re)execute", to_execute.len(),);

    let pb = get_progress_bar_with_msg(to_execute.len() as u64, "Executing");
    to_execute.par_iter().for_each(|(move_file, input)| {
        let output_file = move_file.with_extension("output");
        let result = executor.execute(&input);
        match result {
            Ok(result) => {
                executor.save_result_to_disk(&result, &output_file);
            },
            Err(e) => {
                let error_file = move_file.with_extension("error");
                let msg = format!("{:?}", e);
                pb.println(format!("Error while executing {}", move_file.display(),));
                fs::write(&error_file, msg).unwrap();
            },
        }
        pb.inc(1);
    });

    println!("[3/4] Executed {} files", to_execute.len(),);

    println!(
        "[4/4] Clustered {} runs into {} new errors",
        all_moves.len(),
        executor.pool.lock().unwrap().len(),
    );

    let to_open = executor.generate_report(&cmd.format, &cmd.output_dir);

    println!("[4/4] Saved report to: {:?}", to_open);
    println!("Done checking in {}", HumanDuration(timer.elapsed()));
}
