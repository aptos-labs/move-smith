use crate::execution::{ExecutionResult, Report, ReportFormat, ResultCompareMode};
use anyhow::Result;
use log::{debug, error};
use once_cell::sync::Lazy;
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::{
    collections::BTreeSet, error::Error, fmt::Display, panic::PanicHookInfo, time::Duration,
};

const SUCCESS_MSG: &str = "Success";
const TO_IGNORE: [&str; 14] = [
    "EXTRANEOUS_ACQUIRES_ANNOTATION",
    "infer",
    "MAX_",
    "TOO_MANY",
    "exceeded maximal",
    "EQUALITY_OP_TYPE_MISMATCH_ERROR",
    "unbound",
    "dangling",
    "OUT_OF_GAS",
    // V1 vector bugs
    "READREF_EXISTS_MUTABLE_BORROW_ERROR",
    "CALL_BORROWED_MUTABLE_REFERENCE_ERRO",
    "VEC_UPDATE_EXISTS_MUTABLE_BORROW_ERROR",
    "BORROWLOC_EXISTS_BORROW_ERROR",
    "VEC_BORROW_ELEMENT_EXISTS_MUTABLE_BORROW_ERROR",
    // end V1 vector bugs
];

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
    Panic,
    #[default]
    Unknown,
}

#[derive(Default, Debug, Clone, Eq, Deserialize, Serialize, Hash)]
pub struct ResultChunk {
    #[serde(skip)]
    pub original: String,
    pub canonical: String,
    pub kind: ResultChunkKind,
    #[serde(skip)]
    pub lines: Vec<String>,
}

impl PartialEq for ResultChunk {
    fn eq(&self, other: &Self) -> bool {
        self.canonical == other.canonical
    }
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub enum ResultChunkKind {
    Success,
    #[default]
    Task,
    Error,
    VMError,
    Bug,
    Panic,
    Warning,
    Hash,
    Return,
}

impl ResultChunkKind {
    pub fn try_from_str(msg: &str) -> Option<Self> {
        if msg.contains(SUCCESS_MSG) {
            Some(Self::Success)
        } else if msg.contains("warning") {
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
        } else if msg.starts_with("return") {
            Some(Self::Return)
        } else {
            None
        }
    }
}

#[derive(Default)]
pub struct TransactionalResultBuilder {
    /// Keeps track of the results so far and whether each result is from a V1V2 comparison run (need to split diff)
    ///   - Result from a run
    ///   - Whether the result is a diff
    ///   - Duration of the run
    results: Vec<(Result<(), Box<dyn Error>>, bool)>,
}

impl TransactionalResultBuilder {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn add_result(&mut self, res: Result<(), Box<dyn Error>>, is_diff: bool) -> &mut Self {
        self.results.push((res, is_diff));
        self
    }

    pub fn build(self, duration: Duration) -> TransactionalResult {
        if self.results.iter().all(|(r, _)| r.is_ok()) {
            return TransactionalResult::success();
        }
        let mut result = TransactionalResult::default();
        result.duration = duration;

        let mut log_strings = vec![];
        for (i, (res, is_diff)) in self.results.into_iter().enumerate() {
            result.log.push_str(&format!("Log from run #{}\n", i + 1));
            let run_log = match &res {
                Ok(_) => "Success\n".to_string(),
                Err(e) => format!("{:?}", e),
            };
            for ignore in TO_IGNORE.iter() {
                if run_log.contains(ignore) {
                    return TransactionalResult::success();
                }
            }
            if is_diff {
                let (v1_log, v2_log) = Self::split_diff_log(&run_log);
                log_strings.push(v1_log);
                log_strings.push(v2_log);
            } else {
                log_strings.push(run_log);
            }
        }

        for log in log_strings {
            let lines = log
                .lines()
                .map(|l| l.trim().to_string())
                .collect::<Vec<String>>();
            let chunks = ResultChunk::log_to_chunck(&lines);
            result.log.push_str(&log);
            result.splitted_logs.push(log.clone());
            result.chunks.push(chunks);
        }
        result.initialize();
        result
    }

    fn split_diff_log(log: &str) -> (String, String) {
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
        (left_ori, right_ori)
    }
}

impl TransactionalResult {
    pub fn success() -> Self {
        Self {
            log: SUCCESS_MSG.to_string(),
            status: ResultStatus::Success,
            ..Default::default()
        }
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
            .unwrap_or("no hash found".to_string())
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
            if line.contains("errors differ") {
                continue;
            }
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
            || top.contains("cannot immutably borrow value which is already mutably borrowed")
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

        if top.contains("TOO_MANY")
            || top.contains("exceeded maximal")
            || (top.contains("MAX_") && top.contains("REACHED"))
        {
            return "... too many something...".to_string();
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
        if matches!(self.status, ResultStatus::Panic) {
            writeln!(f, "{}", self.log)?;
            return Ok(());
        }
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
    fn from_panic(panic: &PanicHookInfo) -> Self {
        let log = format!("panicked: {}", panic.location().unwrap());
        Self {
            log,
            status: ResultStatus::Panic,
            ..Default::default()
        }
    }

    fn is_bug(&self) -> bool {
        self.status != ResultStatus::Success
    }

    fn similar(&self, other: &Self, mode: &ResultCompareMode) -> bool {
        if matches!(self.status, ResultStatus::Panic) && matches!(other.status, ResultStatus::Panic)
        {
            let left_loc = self.log.lines().next().unwrap();
            let right_loc = other.log.lines().next().unwrap();
            return left_loc == right_loc;
        }
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
    fn clean(&mut self) {
        if self.status != ResultStatus::Panic {
            self.log.clear();
            self.splitted_logs.clear();
        }
    }

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
