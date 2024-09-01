use crate::execution::{ExecutionResult, Report, ReportFormat, ResultCompareMode};
use anyhow::Result;
use log::{debug, error};
use once_cell::sync::Lazy;
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::{collections::BTreeSet, error::Error, fmt::Display, time::Duration};

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub struct TransactionalResult {
    pub log: String,
    pub splitted_logs: Vec<String>,
    pub status: ResultStatus,
    /// Each element in the outer vector represents a run (e.g. V1 is one run, V2 is another run)
    /// and each element in the inner vector represents a chunk of output (e.g. a warning or an error block)
    pub chunks: Vec<Vec<ResultChunk>>,
    pub hashes: Vec<String>,
    pub duration: Duration,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub enum ResultStatus {
    Success,
    Failure,
    #[default]
    Unknown,
}

#[derive(Default, Debug, Clone, Eq, Deserialize, Serialize, Hash)]
pub struct ResultChunk {
    pub original: String,
    pub canonical: String,
    pub kind: ResultChunkKind,
    pub lines: Vec<String>,
}

impl PartialEq for ResultChunk {
    fn eq(&self, other: &Self) -> bool {
        self.canonical == other.canonical
    }
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub enum ResultChunkKind {
    #[default]
    Task,
    Error,
    VMError,
    Bug,
    Panic,
    Warning,
    Hash,
}

impl ResultChunkKind {
    pub fn try_from_str(msg: &str) -> Option<Self> {
        if msg.contains("warning") {
            Some(Self::Warning)
        } else if msg.contains("task") {
            Some(Self::Task)
        } else if msg.contains("VMError") {
            Some(Self::VMError)
        } else if msg.contains("0xcafe::FuzzStore::AccumulatedHash") {
            Some(Self::Hash)
        } else if msg.starts_with("error") {
            Some(Self::Error)
        } else if msg.starts_with("bug") {
            Some(Self::Bug)
        } else if msg.starts_with("panic") {
            Some(Self::Panic)
        } else {
            None
        }
    }
}

impl TransactionalResult {
    pub fn from_run_result(res: &Result<(), Box<dyn Error>>, duration: Duration) -> Self {
        let mut result = Self::default();
        result.duration = duration;
        match res {
            Ok(_) => {
                result.log = "Success".to_string();
                result.status = ResultStatus::Success;
            },
            Err(e) => {
                let log = format!("{:?}", e);
                let (v1_log, v1_trimmed, v2_log, v2_trimmed) = Self::split_diff_log(&log);
                let v1_chunks = ResultChunk::log_to_chunck(&v1_trimmed);
                let v2_chunks = ResultChunk::log_to_chunck(&v2_trimmed);
                result.log = log;
                result.splitted_logs = vec![v1_log, v2_log];
                result.chunks = vec![v1_chunks, v2_chunks];
            },
        }
        result.initialize();
        result
    }

    // Initialize the status and hashes fields after the chunks are set
    fn initialize(&mut self) {
        if self.chunks.is_empty() {
            return;
        }
        self.hashes = self.chunks.iter().map(|e| Self::extract_hash(e)).collect();
        self.status = Self::check_chunks(&self.chunks);
    }

    fn check_chunks(runs: &[Vec<ResultChunk>]) -> ResultStatus {
        if runs.is_empty() || runs.iter().all(|e| e.is_empty()) {
            return ResultStatus::Success;
        }

        let num_chunks = runs[0].len();
        if runs.iter().any(|e| e.len() != num_chunks) {
            debug!("different number of chunks");
            return ResultStatus::Failure;
        }

        if runs
            .iter()
            .flatten()
            .any(|e| e.kind == ResultChunkKind::Bug)
        {
            debug!("has chunk of kind bug");
            return ResultStatus::Failure;
        }

        for i in 0..num_chunks {
            let canonicals: BTreeSet<String> =
                runs.iter().map(|e| e[i].canonical.clone()).collect();
            if canonicals.len() > 1 {
                debug!("unmatched canonical output: {:#?}", canonicals);
                return ResultStatus::Failure;
            }
        }
        ResultStatus::Success
    }

    fn extract_hash(chunks: &[ResultChunk]) -> String {
        chunks
            .iter()
            .find(|e| e.kind == ResultChunkKind::Hash)
            .map(|e| e.get_canonicalized_msg())
            .unwrap_or("".to_string())
    }

    fn split_diff_log(log: &str) -> (String, Vec<String>, String, Vec<String>) {
        let mut left = vec![];
        let mut right = vec![];
        for line in log.lines() {
            let line = line.trim();
            if line.len() < 2 {
                continue;
            }
            // split line into diff sign and content
            let (diff_sign, content) = line.split_at(2);
            match diff_sign.trim() {
                "-" => left.push(content.to_string()),
                "+" => right.push(content.to_string()),
                "=" => {
                    left.push(content.to_string());
                    right.push(content.to_string());
                },
                _ => (),
            }
        }
        let left_ori = left.join("\n");
        let right_ori = right.join("\n");
        left.iter_mut().for_each(|e| *e = e.trim().to_string());
        right.iter_mut().for_each(|e| *e = e.trim().to_string());
        (left_ori, left, right_ori, right)
    }
}

static LOCAL_PAT: Lazy<Regex> = Lazy::new(|| Regex::new(r"local\s+`[^`]+`").unwrap());

static MODULE_PAT: Lazy<Regex> = Lazy::new(|| Regex::new(r"module\s+'[^']+'").unwrap());

static TYPE_PAT: Lazy<Regex> = Lazy::new(|| Regex::new(r"type\s+`[^`]+`").unwrap());

static SOME_PAT: Lazy<Regex> = Lazy::new(|| Regex::new(r"Some\([^\)]+\)").unwrap());

static ERROR_CODE_PAT: Lazy<Regex> = Lazy::new(|| Regex::new(r"`([^`]*)`").unwrap());

impl ResultChunk {
    fn log_to_chunck(log: &[String]) -> Vec<ResultChunk> {
        let mut chunks = vec![];
        for line in log.iter() {
            if let Some(kind) = ResultChunkKind::try_from_str(line) {
                chunks.push(ResultChunk {
                    original: line.clone(),
                    canonical: String::new(),
                    kind,
                    lines: vec![line.clone()],
                });
            } else if let Some(last_chunk) = chunks.last_mut() {
                last_chunk.lines.push(line.clone());
                last_chunk.original.push('\n');
                last_chunk.original.push_str(line);
            } else {
                error!("cannot parse line: {:?}", line);
            }
        }
        chunks.retain(|e| e.kind != ResultChunkKind::Warning && e.kind != ResultChunkKind::Task);
        chunks
            .iter_mut()
            .for_each(|e| e.canonical = e.get_canonicalized_msg());
        chunks
    }

    fn get_canonicalized_msg(&self) -> String {
        let top = match self.kind {
            ResultChunkKind::VMError => self.lines.get(1).unwrap().trim(),
            ResultChunkKind::Hash => self.lines.get(1).unwrap().split(":").nth(1).unwrap().trim(),
            _ => self.lines.first().unwrap(),
        }
        .to_string();

        let full = &self.original;

        if top.contains("major_status") {
            return top
                .replace("major_status: ", "error_code: ")
                .replace(",", "");
        }
        if top.contains("bytecode verification failed") {
            if let Some(caps) = ERROR_CODE_PAT.captures(&top) {
                return format!("error_code: {}", caps.get(1).unwrap().as_str());
            }
        }

        if top.contains("invalid transfer") || top.contains("cannot transfer") {
            return "... cannot transfer ...".to_string();
        }

        if (full.contains("Invalid acquiring") && full.contains("still being borrowed"))
            || (top.contains("function acquires global")
                && top.contains("which is currently borrowed"))
        {
            return "... cannot acquire borrowed resource ...".to_string();
        }

        if top.contains("mutable ownership violated")
            || (top.contains("cannot mutably borrow")
                && top.contains("since it is already borrowed"))
        {
            return "... cannot mutably borrow while borrowed ...".to_string();
        }

        if top.contains("referential transparency violated")
            || (top.contains("cannot borrow")
                && top.contains("since it is already mutably borrowed"))
        {
            return "... cannot borrow while mutably borrowed ...".to_string();
        }

        if top.contains("cannot extract") {
            return "... cannot extract ...".to_string();
        }

        if top.contains("cannot extract resource") || top.contains("function acquires global") {
            return "... cannot acquire ...".to_string();
        }

        if top.contains("cannot infer type")
            || top.contains("unable to infer instantiation of type")
        {
            return "... cannot infer type ...".to_string();
        }
        let replaced = LOCAL_PAT.replace_all(&top, "[some variable]").to_string();
        let replaced = MODULE_PAT
            .replace_all(&replaced, "[some module]")
            .to_string();
        let replaced = TYPE_PAT.replace_all(&replaced, "[some type]").to_string();
        let replaced = SOME_PAT.replace_all(&replaced, "[some value]").to_string();
        replaced
    }
}

impl Display for TransactionalResult {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        for (i, chunk) in self.chunks.iter().enumerate() {
            writeln!(f, "\n#{} output:", i + 1)?;
            for chunk in chunk.iter() {
                writeln!(f, "{}", chunk.canonical)?;
            }
        }
        writeln!(f, "Status: {:?}", self.status)?;
        writeln!(f, "Duration: {:?}", self.duration)?;
        Ok(())
    }
}

impl ExecutionResult for TransactionalResult {
    fn is_bug(&self) -> bool {
        self.status != ResultStatus::Success
    }

    fn similar(&self, other: &Self, mode: &ResultCompareMode) -> bool {
        match mode {
            ResultCompareMode::Exact => self.chunks == other.chunks,
            ResultCompareMode::SameError => {
                let left_errors = collect_errors(&self.chunks);
                let right_errors = collect_errors(&other.chunks);
                left_errors == right_errors
            },
        }
    }
}

impl Report for TransactionalResult {
    fn to_report(&self, format: &ReportFormat) -> String {
        match format {
            ReportFormat::Text => self.to_string(),
            _ => unimplemented!(),
        }
    }
}

fn collect_errors(chunks: &[Vec<ResultChunk>]) -> Vec<BTreeSet<String>> {
    chunks
        .iter()
        .map(|e| {
            e.iter()
                .filter(|e| {
                    e.kind == ResultChunkKind::Error
                        || e.kind == ResultChunkKind::VMError
                        || e.kind == ResultChunkKind::Bug
                })
                .map(|e| e.canonical.clone())
                .collect()
        })
        .collect()
}
