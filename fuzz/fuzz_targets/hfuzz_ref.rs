use honggfuzz::fuzz;
use msmith::{
    execution::{
        comparison::{ComparisonExecutor, ComparisonInputs, ComparisonOneInput, ComparisonOutput},
        transactional::{result::ResultChunkKind, TransactionalResult, V2Setting},
        ExecutionManager,
    },
    MoveSmith,
};
use once_cell::sync::Lazy;
use std::sync::{Arc, Mutex};

static RUNNER: Lazy<Mutex<ExecutionManager<ComparisonOutput, ComparisonExecutor>>> =
    Lazy::new(|| Mutex::new(ExecutionManager::<ComparisonOutput, ComparisonExecutor>::default()));

fn has_any_error(result: &TransactionalResult) -> bool {
    result.chunks.iter().any(|run| {
        run.iter().any(|chunk| {
            matches!(
                chunk.kind,
                ResultChunkKind::Error
                    | ResultChunkKind::VMError
                    | ResultChunkKind::Panic
                    | ResultChunkKind::Bug
            )
        })
    })
}

fn one_result_checker(_result: &TransactionalResult) -> bool {
    true
}

fn all_results_checker(results: &[TransactionalResult]) -> bool {
    if results.len() != 2 {
        return false;
    }
    let no_check = results.first().unwrap();
    if has_any_error(no_check) {
        // If we encounter any error without compiler checks, we ignore the comparison.
        println!("First result has error chunk, ignoring comparison");
        return true;
    }

    let with_check = results.last().unwrap();
    if has_any_error(with_check) {
        // If we encounter any error with compiler checks, we consider it a bug.
        return false;
    }

    println!("Both results executed successfully, no bug found");
    true
}

fn main() {
    loop {
        fuzz!(|data: &[u8]| {
            let smith = MoveSmith::new();
            let code = match smith.generate(data) {
                Ok(code) => code,
                Err(_) => return,
            };

            let no_check_run = ComparisonOneInput {
                code: code.clone(),
                v2_setting: Some(V2Setting::NoV3RefNoAbility),
                checker: Arc::new(one_result_checker),
            };

            let with_check_run = ComparisonOneInput {
                code: code.clone(),
                v2_setting: Some(V2Setting::Optimization),
                checker: Arc::new(one_result_checker),
            };

            let comparison_inputs = ComparisonInputs {
                inputs: vec![no_check_run, with_check_run],
                checker: Arc::new(all_results_checker),
            };

            let bug = RUNNER
                .lock()
                .unwrap()
                .execute_check_new_bug(&comparison_inputs);
            if bug.unwrap() {
                panic!("Found bug")
            }
        });
    }
}
