// use aptos_transactional_test_harness::run_aptos_test_with_config;
use log::trace;
use msmith::execution::{
    transactional::{
        result::ResultChunk, CommonRunConfig, TransactionalExecutor, TransactionalInputBuilder,
        result::ResultChunkKind,
    },
    Executor,
};
use std::path::{Path, PathBuf};
use std::env;

fn execute_one(path: &Path) {
    trace!("Running test for file: {:?}", path);
    let mut input_builder = TransactionalInputBuilder::new();
    let input = input_builder
        .load_code_from_file(PathBuf::from(path))
        .with_common_runs(&CommonRunConfig::V2OptLevels)
        .build();

    let runner = TransactionalExecutor::default();
    let result = runner.execute_one(&input);

    // Only show error message on the normal optimization level
    let mut output = vec![];
    let empty_chunks = vec![];
    let chunks = result.chunks.get(1).unwrap_or(&empty_chunks);

    let error_chunks: Vec<&ResultChunk> = chunks.iter().filter(|chunk| matches!(chunk.kind, ResultChunkKind::Error | ResultChunkKind::VMError)).collect();
    let bug_chunks: Vec<&ResultChunk> = chunks.iter().filter(|chunk| matches!(chunk.kind, ResultChunkKind::Bug | ResultChunkKind::Panic)).collect();
    output.push(format!("{}", error_chunks.len()));
    output.push(format!("{}", bug_chunks.len()));
    for chunk in error_chunks {
        output.push(chunk.original.clone());
    }
    println!("{}", output.join("\n"));
}

fn main() {
    env::set_var("TO_IGNORE_PATH", "NONE");
    env::set_var("TO_IGNORE_LINES", "LINKER_ERROR");

    let args: Vec<String> = std::env::args().collect();
    let path = Path::new(&args[1]);
    if path.is_file() {
        execute_one(path);
    } else {
        eprintln!("Provided path is not a file.");
    }
}
