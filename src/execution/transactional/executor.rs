use crate::{
    config::CompilerSetting,
    execution::{transactional::TransactionalResult, Executor, Report, ReportFormat},
    utils::create_tmp_move_file,
};
#[cfg(feature = "git_deps")]
use move_model::metadata::LanguageVersion;
#[cfg(feature = "local_deps")]
use move_model_local::metadata::LanguageVersion;
#[cfg(feature = "git_deps")]
use move_transactional_test_runner::{vm_test_harness, vm_test_harness::TestRunConfig};
#[cfg(feature = "local_deps")]
use move_transactional_test_runner_local::{vm_test_harness, vm_test_harness::TestRunConfig};
use std::{panic, path::PathBuf, time::Instant};
use tempfile::TempDir;

#[derive(Default)]
pub struct TransactionalExecutor;

#[derive(Clone)]
pub struct TransactionalInput {
    pub file: Option<PathBuf>,
    pub code: String,
    pub config: CompilerSetting,
}

impl Report for TransactionalInput {
    fn to_report(&self, _format: &ReportFormat) -> String {
        match &self.file {
            Some(file) => format!("{:?}", file),
            None => "".to_string(),
        }
    }
}

impl TransactionalInput {
    pub fn new_from_file(file: PathBuf, config: &CompilerSetting) -> Self {
        let code = std::fs::read_to_string(&file).unwrap();
        Self {
            file: Some(file),
            code,
            config: config.clone(),
        }
    }

    pub fn new_from_str(code: &str, config: &CompilerSetting) -> Self {
        Self {
            file: None,
            code: code.to_string(),
            config: config.clone(),
        }
    }

    pub fn set_report_file(&mut self, file: PathBuf) {
        self.file = Some(file);
    }

    pub fn get_file_path(&self) -> (PathBuf, TempDir) {
        create_tmp_move_file(&self.code, None)
    }
}

impl Executor for TransactionalExecutor {
    type ExecutionResult = TransactionalResult;
    type Input = TransactionalInput;

    fn execute_one(&self, input: &TransactionalInput) -> TransactionalResult {
        let (path, dir) = input.get_file_path();

        let experiments = input.config.to_expriments();
        let vm_test_config = TestRunConfig::ComparisonV1V2 {
            language_version: LanguageVersion::V2_0,
            v2_experiments: experiments,
        };

        let prev_hook = panic::take_hook();
        panic::set_hook(Box::new(|_| {}));
        let start = Instant::now();
        let result = match panic::catch_unwind(|| {
            vm_test_harness::run_test_with_config_and_exp_suffix(vm_test_config, &path, &None)
        }) {
            Ok(res) => res,
            Err(e) => Err(anyhow::anyhow!("{:?}", e).into()),
        };
        let duration = start.elapsed();
        panic::set_hook(prev_hook);

        let output = TransactionalResult::from_run_result(&result, duration);
        dir.close().unwrap();
        output
    }
}
