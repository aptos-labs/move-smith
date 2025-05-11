use crate::execution::{
    transactional::{
        ExecutionMode, TransactionalExecutor, TransactionalInput, TransactionalInputBuilder,
        TransactionalResult, V2Setting,
    },
    ExecutionResult, Executor, Report, ReportFormat, ResultCompareMode,
};
use log::warn;
use serde::{Deserialize, Serialize};
use std::{panic::PanicHookInfo, sync::Arc};

pub type OneResultChecker = Arc<dyn Fn(&TransactionalResult) -> bool + Send + Sync>;
pub type AllResultsChecker = Arc<dyn Fn(&[TransactionalResult]) -> bool + Send + Sync>;

#[derive(Clone)]
pub struct ComparisonOneInput {
    pub code: String,
    pub v2_setting: Option<V2Setting>,
    pub checker: OneResultChecker,
}

impl ComparisonOneInput {
    pub fn to_tx_input(&self) -> TransactionalInput {
        let mut builder = TransactionalInputBuilder::new();
        builder.set_code(&self.code);
        builder.add_run(ExecutionMode::V2Only, self.v2_setting.clone());
        builder.build()
    }
}

/// Input for the compile executor
#[derive(Clone)]
pub struct ComparisonInputs {
    pub inputs: Vec<ComparisonOneInput>,
    pub checker: AllResultsChecker,
}

impl Report for ComparisonInputs {
    fn clean(&mut self) {
        self.inputs.clear();
    }

    fn to_report(&self, _format: &ReportFormat) -> String {
        let mut s = String::new();
        for (i, input) in self.inputs.iter().enumerate() {
            s.push_str(&format!("Input {i}: {:?}\n", input.v2_setting));
        }
        s
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize, Hash)]
pub struct ComparisonOutput {
    pub is_bug: bool,
    pub panic_log: String,
    pub tx_results: Vec<TransactionalResult>,
}

impl Report for ComparisonOutput {
    fn clean(&mut self) {
        for tx in &mut self.tx_results {
            tx.clean();
        }
    }

    fn to_report(&self, format: &ReportFormat) -> String {
        if !self.is_bug {
            return "No bug found".to_string();
        }

        return self
            .tx_results
            .iter()
            .map(|tx| tx.to_report(format))
            .collect::<Vec<_>>()
            .join("\n\n");
    }
}

impl ExecutionResult for ComparisonOutput {
    fn from_panic(panic: &PanicHookInfo) -> Self {
        let log = format!("panicked: {}", panic.location().unwrap());
        Self {
            is_bug: true,
            panic_log: log,
            tx_results: vec![],
        }
    }

    fn is_bug(&self) -> bool {
        self.is_bug
    }

    fn similar(&self, _other: &Self, _mode: &ResultCompareMode) -> bool {
        warn!("ComparisonOutput::similar is not implemented");
        false
    }
}

#[derive(Default)]
pub struct ComparisonExecutor;

impl Executor<ComparisonOutput> for ComparisonExecutor {
    type Input = ComparisonInputs;

    fn execute_one(&self, inputs: &ComparisonInputs) -> ComparisonOutput {
        let executor = TransactionalExecutor;
        let mut all_results = vec![];

        for input in &inputs.inputs {
            let tx_input = input.to_tx_input();
            let result = executor.execute_one(&tx_input);
            all_results.push(result.clone());

            let check_result = (input.checker)(&result);

            if !check_result {
                return ComparisonOutput {
                    is_bug: true,
                    panic_log: String::new(),
                    tx_results: all_results,
                };
            }
        }

        let all_check_result = (inputs.checker)(&all_results);
        ComparisonOutput {
            is_bug: !all_check_result,
            panic_log: String::new(),
            tx_results: all_results,
        }
    }
}
