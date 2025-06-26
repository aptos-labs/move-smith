// use aptos_transactional_test_harness::run_aptos_test_with_config;
use log::trace;
use move_model::metadata::LanguageVersion;
use move_transactional_test_runner::{vm_test_harness, vm_test_harness::TestRunConfig};
use move_vm_runtime::config::VMConfig;
use std::path::Path;
use utils::get_default_compiler_experiments;

fn execute_one(path: &Path) {
    trace!("Running test for file: {:?}", path);
    let test_config = TestRunConfig::CompilerV2 {
        language_version: LanguageVersion::V2_2,
        experiments: get_default_compiler_experiments(),
        vm_config: VMConfig {
            paranoid_type_checks: true,
            ..VMConfig::default()
        },
    };
    let result = vm_test_harness::run_test_with_config_and_exp_suffix(test_config, &path, &None);
    match result {
        Ok(_) => println!("move-test-runner:all-passed"),
        Err(e) => println!("{e:?}"),
    }
}

fn main() {
    // Get file path from first argument
    let args: Vec<String> = std::env::args().collect();
    // Use first argument as the file path
    let path = Path::new(&args[1]);
    // If path is a file, execute the test
    // if it's a directory, iterate over files
    if path.is_file() {
        execute_one(path);
    } else if path.is_dir() {
        for entry in std::fs::read_dir(path).expect("Failed to read directory") {
            let entry = entry.expect("Failed to read entry");
            // check the file end's with .move
            if entry.path().extension().map_or(false, |ext| ext == "move") && entry.path().is_file()
            {
                execute_one(&entry.path());
            }
        }
    } else {
        eprintln!("Provided path is neither a file nor a directory.");
    }
}
