pub mod transactional;

pub enum ReportFormat {
    Text,
    Markdown,
    Html,
    Json,
}

pub enum ResultCompareMode {
    Exact,
    Similar,
}

pub trait ExecutionResult {
    fn is_bug(&self) -> bool;
    fn similar(&self, other: &Self, mode: ResultCompareMode) -> bool;
    fn to_report(&self, format: ReportFormat) -> String;
}
/// An executor is responsible for execute tests, parse their results, and avoid duplications
pub trait Executor {
    type Input;
    type ExecutionResult: ExecutionResult;

    /// Execute one test
    fn execute_one(&self, input: &Self::Input) -> Self::ExecutionResult;
}

pub trait ResultPool {
    type ResultType: ExecutionResult;

    /// Save the execution result to avoid future duplication
    fn add_result(&mut self, result: Self::ResultType);
    /// Check if the result can be ignored (e.g. have seen similar one)
    fn should_ignore(&self, result: &Self::ResultType) -> bool;
}
