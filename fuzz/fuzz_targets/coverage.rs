#![no_main]
use libfuzzer_sys::fuzz_target;
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

fuzz_target!(|data: &[u8]| {
    let code = String::from_utf8_lossy(data).to_string();

    let mut input_builder = TransactionalInputBuilder::new();
    let input = input_builder
        .set_code(&code)
        .with_common_runs(&CommonRunConfig::Default)
        .build();

    let _ = RUNNER.lock().unwrap().execute_without_save(&input);
});
