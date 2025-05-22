use honggfuzz::fuzz;
use msmith::{
    execution::{
        transactional::{
            CommonRunConfig, TransactionalExecutor, TransactionalInputBuilder, TransactionalResult,
        },
        ExecutionManager,
    },
    MoveSmith,
};
use once_cell::sync::Lazy;
use std::sync::Mutex;

static RUNNER: Lazy<Mutex<ExecutionManager<TransactionalResult, TransactionalExecutor>>> =
    Lazy::new(|| {
        Mutex::new(ExecutionManager::<TransactionalResult, TransactionalExecutor>::default())
    });

fn main() {
    loop {
        fuzz!(|data: &[u8]| {
            let smith = MoveSmith::new();
            let code = match smith.generate(data) {
                Ok(code) => code,
                Err(_) => return,
            };

            let mut input_builder = TransactionalInputBuilder::new();
            let input = input_builder
                .set_code(&code)
                .with_common_runs(&CommonRunConfig::V2NoOptExtra)
                .build();

            let bug = RUNNER.lock().unwrap().execute_check_new_bug(&input);
            if bug.unwrap() {
                panic!("Found bug")
            }
        });
    }
}
