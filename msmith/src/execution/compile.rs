use crate::execution::{
    transactional::{
        ExecutionMode, TransactionalExecutor, TransactionalInput, TransactionalInputBuilder,
        TransactionalResult, V2Setting,
    },
    ExecutionResult, Executor, Report, ReportFormat, ResultCompareMode,
};
use serde::{Deserialize, Serialize};
use std::{panic::PanicHookInfo, time::Duration};

/// Input for the compile executor
#[derive(Clone)]
pub struct CompileInput {
    /// The code to compile
    pub code: String,
    /// Compile with V1; should not be used with V2
    pub v1: bool,
    /// Compile with V2; should not be used with V1
    pub v2: bool,
    /// Should be used with V2
    pub v2_setting: Option<V2Setting>,
}

impl CompileInput {
    pub fn new_v1(code: String) -> Self {
        Self {
            code,
            v1: true,
            v2: false,
            v2_setting: None,
        }
    }

    pub fn new_v2(code: String, v2_setting: V2Setting) -> Self {
        Self {
            code,
            v1: false,
            v2: true,
            v2_setting: Some(v2_setting),
        }
    }

    pub fn to_transactional_input(&self) -> TransactionalInput {
        let mut builder = TransactionalInputBuilder::new();
        builder.set_code(&self.code);
        if self.v1 {
            builder.add_run(ExecutionMode::V1Only, None);
        } else {
            builder.add_run(ExecutionMode::V2Only, self.v2_setting.clone());
        }
        builder.build()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub struct CompileResult {
    pub status: CompileStatus,
    pub log: String,
    pub duration: Duration,
}

impl CompileResult {
    pub fn from_transactional_result(result: &TransactionalResult) -> Self {
        let log = result.log.clone();
        let status = if log.contains("compilation errors") {
            CompileStatus::Failure
        } else {
            CompileStatus::Success
        };
        let duration = result.duration;
        Self {
            log,
            status,
            duration,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub enum CompileStatus {
    Success,
    Failure,
    Panic,
}

impl Report for CompileInput {
    fn clean(&mut self) {}

    fn to_report(&self, _format: &ReportFormat) -> String {
        format!(
            "V1: {}, V2: {}\n, V2 Setting: {:?}\nCode:\n{}",
            self.v1, self.v2, self.v2_setting, self.code
        )
    }
}

impl ExecutionResult for CompileResult {
    fn from_panic(panic: &PanicHookInfo) -> Self {
        let log = format!("panicked: {}", panic.location().unwrap());
        Self {
            status: CompileStatus::Panic,
            log,
            duration: Duration::default(),
        }
    }

    fn is_bug(&self) -> bool {
        self.status != CompileStatus::Success
    }

    fn similar(&self, other: &Self, _mode: &ResultCompareMode) -> bool {
        if self.status == CompileStatus::Panic && other.status == CompileStatus::Panic {
            return self.log.lines().next().unwrap() == other.log.lines().next().unwrap();
        }
        self.status == other.status
    }
}

impl Report for CompileResult {
    fn clean(&mut self) {}

    fn to_report(&self, format: &ReportFormat) -> String {
        match format {
            ReportFormat::Text => format!("{:?}\n\n{}", self.status, self.log),
            _ => unimplemented!(),
        }
    }
}

#[derive(Default)]
pub struct CompileExecutor;

impl Executor<CompileResult> for CompileExecutor {
    type Input = CompileInput;

    fn execute_one(&self, input: &CompileInput) -> CompileResult {
        if let Some(v2_setting) = &input.v2_setting {
            set_v2_experiments(v2_setting);
        }
        if input.v1 && input.v2 {
            panic!("Cannot compile with both V1 and V2");
        }

        let executor = TransactionalExecutor;
        let input = input.to_transactional_input();
        let result = executor.execute_one(&input);
        CompileResult::from_transactional_result(&result)
    }
}

fn set_v2_experiments(setting: &V2Setting) {
    let mut feats = vec![];
    let experiments = setting.to_experiments();
    for (exp, enabled) in experiments.iter() {
        feats.push(format!("{}={}", exp, if *enabled { "on" } else { "off" }));
    }
    let feats_value = feats.join(",");
    std::env::set_var("MVC_EXP", feats_value);
}

pub fn print_compile_result(input: &CompileInput, result: &CompileResult) {
    let version = if input.v1 { "v1" } else { "v2" };
    println!("{}", result.log);
    let msg = match result.status {
        CompileStatus::Success => format!(
            "Successfully compiled with {} in {}ms",
            version,
            result.duration.as_millis()
        ),
        CompileStatus::Failure => format!(
            "Failed to compile with {} in {}ms",
            version,
            result.duration.as_millis()
        ),
        CompileStatus::Panic => format!("Paniced during {} compilation", version),
    };
    println!("{}", msg);
}
