use log::{warn, LevelFilter};
use msmith::execution::ExecutionResult;
#[allow(unused)]
use msmith::{
    execution::{
        comparison::{ComparisonExecutor, ComparisonInputs, ComparisonOneInput, ComparisonOutput},
        compile::{print_compile_result, CompileExecutor, CompileInput, CompileStatus},
        transactional::{
            CommonRunConfig, TransactionalExecutor, TransactionalInputBuilder, TransactionalResult,
            V2Setting,
        },
        ExecutionManager, Executor,
    },
    MoveSmith, Variant,
};
use rand::{rngs::StdRng, Rng, SeedableRng};
use std::sync::Arc;

pub fn main() {
    env_logger::init();
    let mut rng = StdRng::seed_from_u64(123);
    let mut buffer = vec![0u8; 1024 * 16];
    rng.fill(&mut buffer[..]);
    let ms = MoveSmith::new();
    // let ms = MoveSmith::variant(Variant::FlushWrites);
    let code = ms.generate(&buffer).unwrap();
    println!("{code}");
    if log::max_level() == LevelFilter::Trace {
        warn!("Trace level logging is enabled, skipping compilation & execution.");
        return;
    }

    let compiler = CompileExecutor;
    let comp_input = CompileInput::new_v2(code.clone(), V2Setting::default());
    let comp_result = compiler.execute_one(&comp_input);

    if comp_result.status != CompileStatus::Success {
        print_compile_result(&comp_input, &comp_result, false);
        println!("Compilation failed, skipping execution.");
        return;
    } else {
        print_compile_result(&comp_input, &comp_result, true);
    }

    let input = TransactionalInputBuilder::new()
        .with_common_runs(&CommonRunConfig::V2Only)
        .set_code(&code)
        .build();
    let executor = ExecutionManager::<TransactionalResult, TransactionalExecutor>::new();
    let result = executor.execute(&input);
    match result {
        Ok(result) => {
            println!("Execution succeeded: {:?}", result.status);
        },
        Err(err) => {
            println!("Execution failed: {err:?}");
        },
    }

    let mut inputs = vec![];
    for _ in 0..2 {
        let input = ComparisonOneInput {
            code: code.clone(),
            v2_setting: Some(V2Setting::default()),
            checker: Arc::new(move |result| result.is_bug()),
        };
        inputs.push(input);
    }

    let comp_input = ComparisonInputs {
        inputs,
        checker: Arc::new(|_results| false),
    };

    let executor = ExecutionManager::<ComparisonOutput, ComparisonExecutor>::new();
    let result = executor.execute(&comp_input);
    match result {
        Ok(result) => {
            println!("Comparison succeeded: {:?}", result.is_bug);
        },
        Err(err) => {
            println!("Comparison failed: {err:?}");
        },
    }
}
