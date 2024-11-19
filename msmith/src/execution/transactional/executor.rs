use super::result::TransactionalResultBuilder;
use crate::execution::{
    transactional::{
        input::{ExecutionMode, TransactionalInput},
        TransactionalResult,
    },
    Executor,
};
#[cfg(feature = "git_deps")]
use move_transactional_test_runner::vm_test_harness;
#[cfg(feature = "local_deps")]
use move_transactional_test_runner_local::vm_test_harness;
use std::time::Instant;

#[derive(Default)]
pub struct TransactionalExecutor;

impl Executor<TransactionalResult> for TransactionalExecutor {
    type Input = TransactionalInput;

    fn execute_one(&self, input: &TransactionalInput) -> TransactionalResult {
        let (path, dir) = input.get_file_path();

        let mut result_builder = TransactionalResultBuilder::new();

        let start = Instant::now();
        for run in &input.runs {
            let test_config = run.to_test_framework_config();
            let result =
                vm_test_harness::run_test_with_config_and_exp_suffix(test_config, &path, &None);
            let is_diff = matches!(run.mode, ExecutionMode::V1V2Comparison);
            result_builder.add_result(result, is_diff);
        }
        let duration = start.elapsed();
        let output = result_builder.build(duration);
        dir.close().unwrap();
        output
    }
}
