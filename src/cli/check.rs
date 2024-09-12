// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Checks a corpus of raw input and clusters the errors found.

use crate::{
    cli::{common::get_progress_bar_with_msg, raw2move::raw2move, Check, MoveSmithEnv},
    execution::{
        transactional::{
            TransactionalExecutor, TransactionalInput, TransactionalInputBuilder,
            TransactionalResult,
        },
        ExecutionManager,
    },
};
use core::panic;
use indicatif::HumanDuration;
use rand::{seq::SliceRandom, thread_rng};
use rayon::prelude::*;
use std::{
    collections::BTreeSet,
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

    let mut raw_inputs = vec![];
    let mut move_inputs = vec![];
    let mut ignore_patterns = vec![".output", ".error"];
    ignore_patterns.extend(cmd.ignore.iter().map(|s| s.as_str()));

    for entry in fs::read_dir(corpus_dir).unwrap() {
        let path = entry.unwrap().path();
        if !path.is_file() {
            continue;
        }
        for s in &ignore_patterns {
            if path.display().to_string().contains(s) {
                continue;
            }
        }

        match path.extension() {
            Some(ext) => {
                if ext == "raw" {
                    raw_inputs.push(path);
                } else if ext == "move" {
                    move_inputs.push(path);
                }
            },
            None => raw_inputs.push(path),
        }
    }

    println!(
        "[1/5] Found {} raw input files and {} Move files",
        raw_inputs.len(),
        move_inputs.len(),
    );

    let num_parse = Mutex::new(0usize);
    let num_parse_err = Mutex::new(0usize);

    println!("[2/5] Converting raw inputs files...");
    let pb = get_progress_bar_with_msg(raw_inputs.len() as u64, "Generating");
    let mut all_moves: BTreeSet<PathBuf> = raw_inputs
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
    all_moves.extend(move_inputs.into_iter());

    pb.finish_and_clear();

    println!("[2/5] Converted {} raw inputs", num_parse.lock().unwrap(),);
    println!(
        "[2/5] {} input files cannot be parsed due to errors",
        num_parse_err.lock().unwrap()
    );

    println!("[2/5] Obtained {} Move files in total", all_moves.len(),);

    println!("[3/5] Loading existing results...");
    let pb = get_progress_bar_with_msg(all_moves.len() as u64, "Loading");
    let mut executor = ExecutionManager::<TransactionalResult, TransactionalExecutor>::default();
    executor.set_save_input(true);

    let loaded_num = Mutex::new(0usize);
    let run_config = env.cli.global_options.run.clone().unwrap_or_default();
    let mut to_execute: Vec<(PathBuf, TransactionalInput)> = all_moves
        .par_iter()
        .filter_map(|move_file| {
            let output_file = move_file.with_extension("output");
            let mut input_builder = TransactionalInputBuilder::new();
            let input = input_builder
                .load_code_from_file(move_file.clone())
                .with_common_runs(&run_config)
                .build();
            pb.inc(1);
            if cmd.rerun || !output_file.exists() {
                Some((move_file.clone(), input))
            } else {
                let result = executor.load_result_from_disk(&output_file);
                executor.add_result(&result, Some(&input));
                *loaded_num.lock().unwrap() += 1;
                None
            }
        })
        .collect();
    pb.finish_and_clear();
    println!(
        "[3/5] Loaded {} existing results...",
        loaded_num.lock().unwrap(),
    );

    println!("[4/5] (Re-)Executing {} Move files", to_execute.len(),);
    to_execute.shuffle(&mut thread_rng());
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
    pb.finish_and_clear();

    println!("[4/5] Executed {} files", to_execute.len(),);

    println!(
        "[5/5] Clustered {} runs into {} new errors",
        all_moves.len(),
        executor.pool.lock().unwrap().len(),
    );

    let to_open = executor.generate_report(&cmd.format, &cmd.output_dir);

    println!("[5/5] Saved report to: {:?}", to_open);
    println!("Done checking in {}", HumanDuration(timer.elapsed()));
}
