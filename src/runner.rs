// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Transactional test runner helpers

use crate::{config::FuzzConfig, utils::create_tmp_move_file};
use anyhow::Result;
use glob::glob;
use move_model::metadata::LanguageVersion;
use move_transactional_test_runner::{vm_test_harness, vm_test_harness::TestRunConfig};
use once_cell::sync::Lazy;
use rayon::prelude::*;
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::{
    collections::BTreeSet,
    error::Error,
    fmt::Display,
    fs, panic,
    path::Path,
    time::{Duration, Instant},
};
use toml;

static RE: Lazy<Regex> = Lazy::new(|| {
    Regex::new(r"(local\s+`[^`]+`|module\s+'[^']+')|type\s+`[^`]+`|Some\([^\)]+\)").unwrap()
});

#[derive(Default, Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub struct ErrorLine(pub String);

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct TransactionalTestError {
    #[serde(skip)]
    pub full_log: String,
    #[serde(skip)]
    pub hash_diff: Vec<ErrorLine>,
    pub v1_errors: BTreeSet<ErrorLine>,
    pub v2_errors: BTreeSet<ErrorLine>,
}

impl PartialEq for TransactionalTestError {
    fn eq(&self, other: &Self) -> bool {
        self.v1_errors == other.v1_errors && self.v2_errors == other.v2_errors
    }
}

impl Eq for TransactionalTestError {}

impl PartialOrd for TransactionalTestError {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for TransactionalTestError {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.v1_errors
            .cmp(&other.v1_errors)
            .then(self.v2_errors.cmp(&other.v2_errors))
    }
}

#[derive(Debug, Clone, Default, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub struct Errors {
    pub errors: BTreeSet<TransactionalTestError>,
}

#[derive(Debug, Clone, Default)]
pub struct TransactionalTestStats {
    pub v1_compiler_error: bool,
    pub v2_compiler_error: bool,
    pub v1_runtime_error: usize,
    pub v2_runtime_error: usize,
}

#[derive(Debug, Clone)]
pub struct TransactionalResult {
    pub description: String,
    pub result: Result<String, TransactionalTestError>,
    pub stats: TransactionalTestStats,
    pub duration: Duration,
}

#[derive(Debug, Clone, Default, Deserialize, Serialize)]
pub struct ErrorPool {
    known_errors: Errors,
    ignore_strs: Vec<String>,
}

pub struct Runner {
    config: FuzzConfig,
    pub error_pool: ErrorPool,
}

impl ErrorPool {
    pub fn new(ignore_strs: &[String]) -> Self {
        Self {
            known_errors: Errors::default(),
            ignore_strs: ignore_strs.to_vec(),
        }
    }

    pub fn load_known_errors(&mut self, toml_path: &Path) -> Result<()> {
        let toml_str = std::fs::read_to_string(toml_path).expect("Failed to read TOML file");
        let errors = toml::from_str(&toml_str).expect("Failed to parse TOML file");
        self.known_errors = errors;
        Ok(())
    }

    /// Executes the transactional tests in `known_dir` and store their results
    /// as known errors.
    pub fn process_known_errors_dir(
        runner: &Runner,
        known_dir: &Path,
        toml_path: &Path,
    ) -> Result<()> {
        let mut move_files = vec![];
        let pattern = format!("{}/**/*.move", known_dir.display());
        for entry in glob(&pattern).expect("Failed to read glob pattern") {
            match entry {
                Ok(path) => move_files.push(path),
                Err(e) => println!("{:?}", e),
            }
        }
        println!(
            "Found {} Move files from {}",
            move_files.len(),
            known_dir.display()
        );

        let mut known_errors = move_files
            .par_iter()
            .flat_map(|file| {
                let code = std::fs::read_to_string(file).unwrap();
                runner.run_transactional_test(&code)
            })
            .collect::<Vec<TransactionalResult>>();
        known_errors.retain(|x| x.result.is_err());
        println!("Collected {} errors", known_errors.len());

        let errors = Errors {
            errors: BTreeSet::from_iter(known_errors.iter().map(|x| x.result.clone().unwrap_err())),
        };

        let toml_str = toml::to_string(&errors).expect("Failed to serialize to TOML");
        fs::write(toml_path, toml_str).expect("Failed to write to TOML file");
        println!("Saved errors to {:?}", toml_path);

        Ok(())
    }

    /// Check if we should skip the given result. We skip in case of:
    ///   - The result is Ok, meaning test run successfully
    ///   - The result is the same as a known error
    ///   - The result contains to-ignore strings
    pub fn should_skip_result(&self, result: &TransactionalResult) -> bool {
        if result.result.is_ok() {
            return true;
        }
        self.should_skip_error(result.result.as_ref().unwrap_err())
    }

    pub fn should_skip_error(&self, error: &TransactionalTestError) -> bool {
        if self.known_errors.errors.contains(error) {
            return true;
        }

        if !error.hash_diff.is_empty() {
            return false;
        }

        for ignore_str in self.ignore_strs.iter() {
            if error.full_log.contains(ignore_str) {
                return true;
            }
        }
        false
    }

    pub fn add_known_error(&mut self, error: TransactionalTestError) {
        self.known_errors.errors.insert(error);
    }
}

impl ErrorLine {
    pub fn from_log_line(line: &str) -> Self {
        if line.contains("cannot extract resource") || line.contains("function acquires global") {
            return Self("...cannot acquire...".to_string());
        }
        if line.contains("cannot infer type")
            || line.contains("unable to infer instantiation of type")
        {
            return Self("...cannot infer type...".to_string());
        }
        let replaced = RE
            .replace_all(line, |caps: &regex::Captures| {
                if caps[0].starts_with("local") {
                    "variable".to_string()
                } else if caps[0].starts_with("type") {
                    "type".to_string()
                } else if caps[0].starts_with("module") {
                    "module".to_string()
                } else if caps[0].starts_with("Some") {
                    "Some(value)".to_string()
                } else {
                    panic!("Unexpected match");
                }
            })
            .to_string();
        Self(replaced)
    }

    fn is_error_line(line: &str) -> bool {
        let line = line.trim();
        if line == "Error: compilation errors:"
            || line.starts_with("error with experiment:")
            || line.starts_with("Expected errors differ from actual errors:")
        {
            return false;
        }

        line.contains("error")
            || line.contains("Error")
            || line.contains("ERROR")
            || line.contains("bug:")
            || line.contains("panic")
    }

    fn is_hash_line(line: &str) -> bool {
        line.contains("acc:")
    }

    fn from_hash_line(line: &str) -> Self {
        Self(line.split("acc:").last().unwrap().trim().to_string())
    }

    fn is_empty(&self) -> bool {
        self.0.is_empty()
    }
}

impl Display for TransactionalTestError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "V1 errors:")?;
        for err in self.v1_errors.iter() {
            writeln!(f, "{}", err.0)?;
        }
        writeln!(f, "V2 errors:")?;
        for err in self.v2_errors.iter() {
            writeln!(f, "{}", err.0)?;
        }
        Ok(())
    }
}

impl TransactionalTestError {
    pub fn get_log(&self) -> String {
        self.full_log.clone()
    }

    pub fn from_log(full_log: &str, v1_log: &[String], v2_log: &[String]) -> Option<Self> {
        let mut v1_errors = BTreeSet::new();
        let mut v2_errors = BTreeSet::new();
        let mut v1_hash = ErrorLine::default();
        let mut v2_hash = ErrorLine::default();
        for line in v1_log.iter() {
            if ErrorLine::is_error_line(line) {
                v1_errors.insert(ErrorLine::from_log_line(line));
            }
            if ErrorLine::is_hash_line(line) {
                v1_hash = ErrorLine::from_hash_line(line);
            }
        }
        for line in v2_log.iter() {
            if ErrorLine::is_error_line(line) {
                v2_errors.insert(ErrorLine::from_log_line(line));
            }
            if ErrorLine::is_hash_line(line) {
                v2_hash = ErrorLine::from_hash_line(line);
            }
        }

        let mut hash_diff = vec![];
        if !v1_hash.is_empty() && !v2_hash.is_empty() && v1_hash == v2_hash {
            v1_errors.insert(v1_hash.clone());
            v2_errors.insert(v2_hash.clone());
            hash_diff.push(v1_hash);
            hash_diff.push(v2_hash);
        }

        if v1_errors.is_empty() && v2_errors.is_empty() {
            None
        } else {
            Some(Self {
                full_log: full_log.to_string(),
                hash_diff,
                v1_errors,
                v2_errors,
            })
        }
    }
}

impl TransactionalTestStats {
    pub fn from_log(_v1_log: &[String], _v2_log: &[String]) -> Self {
        Self::default()
    }
}

impl Display for TransactionalResult {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "{}", self.description)?;
        match &self.result {
            Ok(_) => writeln!(f, "Test passed.")?,
            Err(err) => write!(f, "{}", err)?,
        }
        writeln!(f, "Took {}ms", self.duration.as_millis())?;
        Ok(())
    }
}

impl TransactionalResult {
    pub fn from_run_result(
        name: &str,
        duration: Duration,
        res: &Result<(), Box<dyn Error>>,
    ) -> Self {
        match res {
            Ok(()) => Self {
                description: name.to_string(),
                result: Ok("No diff found".to_string()),
                stats: TransactionalTestStats::default(),
                duration,
            },
            Err(e) => {
                let msg = format!("{:?}", e);
                if msg.contains("Compiler v2 delivered same results") {
                    return Self {
                        description: name.to_string(),
                        result: Ok(msg),
                        stats: TransactionalTestStats::default(),
                        duration,
                    };
                }
                let mut v1_log = vec![];
                let mut v2_log = vec![];
                let mut start_v2 = false;
                for line in msg.lines() {
                    let line = line.trim();
                    if line == "V2 Result:" {
                        start_v2 = true;
                    }
                    if start_v2 {
                        v2_log.push(line.to_string());
                    } else {
                        v1_log.push(line.to_string());
                    }
                }
                let result = match TransactionalTestError::from_log(&msg, &v1_log, &v2_log) {
                    Some(err) => Err(err),
                    None => Ok(msg),
                };
                let stats = TransactionalTestStats::from_log(&v1_log, &v2_log);
                Self {
                    description: name.to_string(),
                    result,
                    stats,
                    duration,
                }
            },
        }
    }

    pub fn get_log(&self) -> String {
        match &self.result {
            Ok(log) => log.clone(),
            Err(err) => err.get_log(),
        }
    }
}

impl Runner {
    pub fn new(config: &FuzzConfig) -> Self {
        Self {
            config: config.clone(),
            error_pool: ErrorPool::new(&config.ignore_strs),
        }
    }

    pub fn new_with_errors(config: &FuzzConfig, known_errors: &Errors) -> Self {
        let mut runner = Self::new(config);
        runner.error_pool.known_errors = known_errors.clone();
        runner
    }

    pub fn new_with_known_errors(config: &FuzzConfig, force_reprocess: bool) -> Self {
        let mut runner = Self::new(config);
        let toml_path = config.known_error_dir.join("known_errors.toml");
        if !toml_path.exists() || force_reprocess {
            println!("Processing known errors at {:?}", config.known_error_dir);
            ErrorPool::process_known_errors_dir(&runner, &config.known_error_dir, &toml_path)
                .expect("Failed to process known errors");
        }

        println!("Loading known errors from {:?}", toml_path);
        runner
            .error_pool
            .load_known_errors(&toml_path)
            .expect("Failed to load known errors");
        runner
    }

    /// Execute the given Move code as a transactional test, for all compiler settings
    pub fn run_transactional_test(&self, code: &str) -> Vec<TransactionalResult> {
        let mut results = vec![];
        let (file_path, dir) = create_tmp_move_file(code, None);

        for (name, setting) in self.config.runs().iter() {
            let experiments = setting.to_expriments();
            let vm_test_config = TestRunConfig::ComparisonV1V2 {
                language_version: LanguageVersion::V2_0,
                v2_experiments: experiments,
            };
            let prev_hook = panic::take_hook();
            panic::set_hook(Box::new(|_| {}));
            let start = Instant::now();
            let result = match panic::catch_unwind(|| {
                vm_test_harness::run_test_with_config_and_exp_suffix(
                    vm_test_config,
                    &file_path,
                    &None,
                )
            }) {
                Ok(res) => res,
                Err(e) => Err(anyhow::anyhow!("{:?}", e).into()),
            };
            panic::set_hook(prev_hook);
            let result = TransactionalResult::from_run_result(name, start.elapsed(), &result);
            results.push(result);
        }
        dir.close().unwrap();
        results
    }

    pub fn run_transactional_test_unwrap(&self, code: &str) {
        let results = self.run_transactional_test(code);
        self.check_results(&results);
    }

    pub fn check_results(&self, results: &[TransactionalResult]) {
        for r in results.iter() {
            if !self.error_pool.should_skip_result(r) {
                panic!("Found new error: {}", r.get_log());
            }
        }
    }

    pub fn keep_and_check_results(&mut self, results: &[TransactionalResult]) {
        for r in results.iter() {
            if !self.error_pool.should_skip_result(r) {
                self.error_pool
                    .add_known_error(r.result.clone().unwrap_err());
                panic!("Found new error: {}", r.get_log());
            }
        }
    }
}
