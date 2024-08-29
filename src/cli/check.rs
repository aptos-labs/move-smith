// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Checks a corpus of raw input and clusters the errors found.

use crate::{
    cli::{common::get_progress_bar_with_msg, raw2move::raw2move, Check, MoveSmithEnv},
    runner::{Runner, TransactionalResult, TransactionalTestError},
};
use core::panic;
use glob::glob;
use indicatif::HumanDuration;
use rayon::prelude::*;
use serde::Serialize;
use std::{
    collections::BTreeMap,
    fs,
    path::{Path, PathBuf},
    time::Instant,
};

#[derive(Debug, Clone, Serialize)]
pub struct CheckReportError {
    pub v1: Vec<String>,
    pub v2: Vec<String>,
    pub files: Vec<PathBuf>,
}

#[derive(Debug, Clone, Serialize, Default)]
pub struct CheckReport {
    pub new: BTreeMap<String, CheckReportError>,
    pub ignored: BTreeMap<String, CheckReportError>,
}

impl CheckReportError {
    pub fn from_transactional_error(files: &[PathBuf], e: &TransactionalTestError) -> Self {
        Self {
            v1: e.v1_errors.iter().map(|e| e.0.clone()).collect(),
            v2: e.v2_errors.iter().map(|e| e.0.clone()).collect(),
            files: files.to_vec(),
        }
    }
}

pub fn handle_check(env: &MoveSmithEnv, cmd: &Check) {
    let runner = Runner::new_with_known_errors(&env.config.fuzz, true);
    println!("[1/3] Reloaded known errors...");

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
    println!("[2/3] Found {} crashing input files", all_inputs.len());

    let pb = get_progress_bar_with_msg(all_inputs.len() as u64, "Checking");
    let timer = Instant::now();
    let results = all_inputs
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
                    return vec![];
                }
                code
            };
            let results = runner.run_transactional_test(&code);
            pb.inc(1);
            results
        })
        .collect::<Vec<Vec<TransactionalResult>>>();
    pb.finish_and_clear();
    println!("[2/3] Executed {} crashing input files", all_inputs.len());

    let mut error_map = BTreeMap::new();
    for (input_file, results) in all_inputs.iter().zip(results.iter()) {
        for r in results.iter() {
            if let Err(err) = &r.result {
                let entry = error_map.entry(err).or_insert(vec![]);
                entry.push(input_file.clone());
            }
        }
    }
    let mut report = CheckReport::default();
    for (err, files) in error_map.iter() {
        let report_err = CheckReportError::from_transactional_error(files, err);
        if runner.error_pool.should_skip_error(err) {
            report
                .ignored
                .insert(format!("error-{:0>3}", report.ignored.len()), report_err);
        } else {
            report
                .new
                .insert(format!("error-{:0>3}", report.new.len()), report_err);
        }
    }
    println!(
        "[3/3] Clustered {} runs into {} new errors and {} ignored errors",
        all_inputs.len(),
        report.new.len(),
        report.ignored.len(),
    );
    let toml_str = toml::to_string_pretty(&report).expect("Failed to serialize report to TOML");
    fs::write(&cmd.output_file, toml_str).expect("Failed to write report file");
    println!("Saved report to: {:?}", cmd.output_file);
    println!("Done checking in {}", HumanDuration(timer.elapsed()));
}
