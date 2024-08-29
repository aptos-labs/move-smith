use crate::execution::{ExecutionResult, ReportFormat, ResultCompareMode};
use anyhow::Result;
use log::{debug, error};
use once_cell::sync::Lazy;
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::{collections::BTreeSet, error::Error, fmt::Display, time::Duration};

#[derive(Default, Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub struct TransactionalResult {
    pub log: String,
    pub splitted_logs: Vec<String>,
    pub status: ResultStatus,
    pub chunks: Vec<Vec<ResultChunk>>,
    pub hashes: Vec<String>,
    pub duration: Duration,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub enum ResultStatus {
    Success,
    Failure,
    #[default]
    Unknown,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
pub struct ResultChunk {
    pub original: String,
    pub canonical: String,
    pub kind: ResultChunkKind,
    pub lines: Vec<String>,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Deserialize, Serialize)]
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
        return if msg.contains("warning") {
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
        };
    }
}

impl TransactionalResult {
    pub fn from_run_result(res: &Result<(), Box<dyn Error>>, duration: Duration) -> Self {
        match res {
            Ok(_) => Self {
                log: "Success".to_string(),
                status: ResultStatus::Success,
                splitted_logs: vec![],
                chunks: vec![],
                hashes: vec![],
                duration,
            },
            Err(e) => {
                let log = format!("{:?}", e);
                let (v1_log, v1_trimmed, v2_log, v2_trimmed) = Self::split_diff_log(&log);
                let v1_chunks = ResultChunk::log_to_chunck(&v1_trimmed);
                let v2_chunks = ResultChunk::log_to_chunck(&v2_trimmed);
                let hashes = vec![
                    Self::extract_hash(&v1_chunks),
                    Self::extract_hash(&v2_chunks),
                ];
                let status = Self::check_chunks(&[v1_chunks.clone(), v2_chunks.clone()]);
                Self {
                    log,
                    splitted_logs: vec![v1_log, v2_log],
                    chunks: vec![v1_chunks, v2_chunks],
                    status,
                    hashes,
                    duration,
                }
            },
        }
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
            if let Some(kind) = ResultChunkKind::try_from_str(&line) {
                chunks.push(ResultChunk {
                    original: line.clone(),
                    canonical: String::new(),
                    kind,
                    lines: vec![line.clone()],
                });
            } else if let Some(last_chunk) = chunks.last_mut() {
                last_chunk.lines.push(line.clone());
                last_chunk.original.push_str("\n");
                last_chunk.original.push_str(line);
            } else {
                error!("cannot parse line: {:?}", line);
            }
        }
        chunks.retain(|e| e.kind != ResultChunkKind::Warning);
        chunks
            .iter_mut()
            .for_each(|e| e.canonical = e.get_canonicalized_msg());
        chunks
    }

    fn get_canonicalized_msg(&self) -> String {
        let top = match self.kind {
            ResultChunkKind::VMError => self.lines.get(1).unwrap().trim(),
            ResultChunkKind::Hash => self.lines.get(1).unwrap().split(":").nth(1).unwrap().trim(),
            _ => self.lines.get(0).unwrap(),
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

        if (full.contains("Invalid acquiring") && full.contains("still being borrowed"))
            || (top.contains("function acquires global")
                && top.contains("which is currently borrowed"))
        {
            return "... cannot acquire borrowed resource ...".to_string();
        }

        if top.contains("mutable ownership violated")
            || top.contains("which is still mutably borrowed")
        {
            return "... cannot copy while mutably borrowed ...".to_string();
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
        return self.status != ResultStatus::Success;
    }

    fn similar(&self, other: &Self, mode: ResultCompareMode) -> bool {
        unimplemented!()
    }

    fn to_report(&self, format: ReportFormat) -> String {
        match format {
            ReportFormat::Text => self.to_string(),
            _ => unimplemented!(),
        }
    }
}
