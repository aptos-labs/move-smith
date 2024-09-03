use anyhow::Result;
use clap::ValueEnum;
use serde::{Deserialize, Serialize};
use std::{
    collections::{HashMap, HashSet},
    fs,
    hash::Hash,
    path::{Path, PathBuf},
    sync::Mutex,
};

pub mod transactional;

#[derive(ValueEnum, Clone, Debug)]
pub enum ReportFormat {
    Text,
    Markdown,
    Html,
    Json,
}

pub trait Report {
    fn to_report(&self, format: &ReportFormat) -> String;
}

#[derive(PartialEq)]
pub enum ResultCompareMode {
    // Exactly same canonical output in the same order for each run
    Exact,
    // For each run, the reported errors/bugs are the same
    SameError,
}

pub trait ExecutionResult: Report {
    fn is_bug(&self) -> bool;
    fn similar(&self, other: &Self, mode: &ResultCompareMode) -> bool;
}
/// An executor is responsible for execute tests, parse their results, and avoid duplications
pub trait Executor<R: ExecutionResult> {
    type Input: Clone + Report;

    /// Execute one test
    fn execute_one(&self, input: &Self::Input) -> R;
}

/// An execution manager is responsible for saving and clustering the results of test executions
pub struct ExecutionManager<R: ExecutionResult + Eq + Hash + Clone, E: Executor<R>> {
    save_input: bool,
    save_to_disk_path: Option<PathBuf>,
    compare_mode: ResultCompareMode,
    pub executor: E,
    pub pool: Mutex<HashSet<R>>,
    pub input_map: Mutex<HashMap<R, Vec<E::Input>>>,
}

impl<R, E> Default for ExecutionManager<R, E>
where
    R: ExecutionResult + Eq + Hash + Clone,
    E: Executor<R> + Default,
{
    fn default() -> Self {
        Self {
            save_input: false,
            save_to_disk_path: None,
            compare_mode: ResultCompareMode::SameError,
            executor: E::default(),
            pool: Mutex::new(HashSet::new()),
            input_map: Mutex::new(HashMap::new()),
        }
    }
}

impl<R, E> ExecutionManager<R, E>
where
    R: ExecutionResult + Eq + Hash + Clone + Serialize + for<'de> Deserialize<'de>,
    E: Executor<R> + Default,
{
    pub fn new() -> Self {
        Self::default()
    }

    pub fn set_compare_mode(&mut self, mode: ResultCompareMode) {
        self.compare_mode = mode;
    }

    pub fn set_save_input(&mut self, save_input: bool) {
        self.save_input = save_input;
    }

    pub fn set_save_to_disk_path(&mut self, path: Option<PathBuf>) {
        self.save_to_disk_path = path;
    }

    pub fn add_result(&self, result: &R, input: Option<&E::Input>) {
        let mut pool = self.pool.lock().unwrap();
        let mut map = self.input_map.lock().unwrap();

        for r in pool.iter() {
            if result.similar(r, &self.compare_mode) {
                return;
            }
        }

        pool.insert(result.clone());
        if self.save_input {
            if let Some(input) = input {
                map.entry(result.clone()).or_default().push(input.clone());
            }
        }
    }

    pub fn seen_similar_result(&self, result: &R) -> bool {
        for r in self.pool.lock().unwrap().iter() {
            if result.similar(r, &self.compare_mode) {
                return true;
            }
        }
        false
    }

    pub fn execute_without_save(&self, input: &E::Input) -> Result<R> {
        Ok(self.executor.execute_one(input))
    }

    /// Execute a test and save the result to the pool
    pub fn execute(&self, input: &E::Input) -> Result<R> {
        let result = self.execute_without_save(input);
        if let Ok(result) = &result {
            self.add_result(result, Some(input));
        }
        result
    }

    /// Execute a test and save the result to the pool
    /// Return true if
    ///     - the result is a bug AND it has not been seen before
    /// Return false if
    ///     - the result is not a bug OR
    ///     - the result is a bug but has been seen before
    pub fn execute_check_new_bug(&self, input: &E::Input) -> Result<bool> {
        let result = self.execute_without_save(input);
        if let Ok(result) = &result {
            let bug = result.is_bug() && !self.seen_similar_result(result);
            self.add_result(result, Some(input));
            Ok(bug)
        } else {
            result.map(|_| false)
        }
    }

    pub fn generate_report(&self, format: &ReportFormat, output_dir: &Path) -> PathBuf {
        fs::create_dir_all(output_dir).unwrap();
        match format {
            ReportFormat::Text => {
                let mut cnt = 0;
                let mut report = "".to_string();
                self.input_map
                    .lock()
                    .unwrap()
                    .iter()
                    .for_each(|(result, inputs)| {
                        cnt += 1;
                        report.push_str(&format!("Cluster #{}\n", cnt));
                        report.push_str(&result.to_report(format));
                        report.push_str("\nFiles:\n");
                        for input in inputs {
                            report.push_str(&input.to_report(format));
                            report.push('\n');
                        }
                        report.push_str("###################\n");
                    });
                let output_file = output_dir.join("report.txt");
                fs::write(&output_file, report).unwrap();
                output_file
            },
            _ => unimplemented!(),
        }
    }

    pub fn save_result_to_disk(&self, result: &R, output_file: &Path) {
        fs::write(&output_file, serde_json::to_string(result).unwrap()).unwrap();
    }

    pub fn load_result_from_disk(&self, input: &Path) -> R {
        let content = fs::read_to_string(input).unwrap();
        serde_json::from_str(&content).unwrap()
    }
}
