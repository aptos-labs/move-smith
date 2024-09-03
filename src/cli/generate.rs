// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! Generate Move files or packages with a given seed.

use crate::{
    cli::{common::get_progress_bar_with_msg, raw2move::raw2move, Generate, MoveSmithEnv},
    config::GenerationConfig,
    execution::{
        transactional::{TransactionalExecutor, TransactionalInput, TransactionalResult},
        ExecutionManager,
    },
    utils::create_move_package,
};
use indicatif::{HumanDuration, ParallelProgressIterator};
use rand::{rngs::StdRng, Rng, SeedableRng};
use rayon::prelude::*;
use std::{fs, path::PathBuf, time::Instant};

const BUFFER_SIZE_START: usize = 1024 * 16;

pub fn handle_generate(env: &MoveSmithEnv, cmd: &Generate) {
    fs::create_dir_all(&cmd.output_dir).unwrap();
    let seeds = generate_seeds(cmd.seed, cmd.num);

    let files = (0..cmd.num)
        .map(|i| match cmd.package {
            true => cmd.output_dir.join(format!("Package-{}", i)),
            false => cmd.output_dir.join(format!("MoveSmith-{}.move", i)),
        })
        .collect::<Vec<PathBuf>>();

    println!("[1/2] Generating Move files...");
    let timer = Instant::now();
    let codes = files
        .par_iter()
        .zip(seeds.par_iter())
        .progress_with(get_progress_bar_with_msg(cmd.num, "Generating"))
        .map(|(file, seed)| {
            generate_move_with_seed(&env.config.generation, file, *seed, cmd.package)
        })
        .collect::<Vec<String>>();
    println!(
        "[1/2] Done generating {} Move files in {}",
        cmd.num,
        HumanDuration(timer.elapsed())
    );

    if !cmd.skip_run {
        println!("[2/2] Running transactional tests...");
        let executor = ExecutionManager::<TransactionalResult, TransactionalExecutor>::default();
        let setting = env
            .config
            .get_compiler_setting(env.cli.global_options.use_setting.as_str())
            .unwrap();
        let pb = get_progress_bar_with_msg(cmd.num, "Running");
        let timer = Instant::now();
        let results = codes
            .par_iter()
            .map(|code| {
                let input = TransactionalInput::new_from_str(code, setting);
                let result = executor.execute_check_new_bug(&input);
                pb.inc(1);
                result.unwrap_or(false)
            })
            .collect::<Vec<bool>>();
        pb.finish_and_clear();

        let failed_files = files
            .iter()
            .zip(results.iter())
            .filter_map(|(f, r)| if *r { Some(f) } else { None })
            .collect::<Vec<&PathBuf>>();
        if !cmd.ignore_error {
            println!(
                "[2/2] Got {} errors: {:#?}",
                failed_files.len(),
                failed_files
            );
        }
        // Write the list of failed files to a file
        let failed_files_path = cmd.output_dir.join("failed_files.txt");
        fs::write(
            &failed_files_path,
            failed_files
                .iter()
                .map(|f| f.to_string_lossy())
                .collect::<Vec<_>>()
                .join("\n"),
        )
        .unwrap();
        println!(
            "[2/2] Error rate: {}/{} = {:.2}%",
            failed_files.len(),
            cmd.num,
            failed_files.len() as f64 / cmd.num as f64 * 100.0
        );
        println!(
            "[2/2] Done running transactional tests in {}",
            HumanDuration(timer.elapsed())
        );
    } else {
        println!("[2/2] Skipping transactional tests...");
    }
    println!("All done!")
}

fn generate_seeds(seed: u64, num: u64) -> Vec<u64> {
    let mut rng = rand::rngs::StdRng::seed_from_u64(seed);
    (0..num).map(|_| rng.gen()).collect()
}

/// If `package` is true, the `output_path` should be the path to the `.move` file.
/// If `package` is false, the `output_path` should be the path to the directory where the package will be saved.
fn generate_move_with_seed(
    conf: &GenerationConfig,
    output_path: &PathBuf,
    seed: u64,
    package: bool,
) -> String {
    let mut rng = StdRng::seed_from_u64(seed);
    let mut buffer_size = BUFFER_SIZE_START;
    let mut buffer = vec![];
    let code = loop {
        if buffer_size > buffer.len() {
            let diff = buffer_size - buffer.len();
            let mut new_buffer = vec![0u8; diff];
            rng.fill(&mut new_buffer[..]);
            buffer.extend(new_buffer);
        }
        let (success, log, code) = raw2move(conf, &buffer);
        if log.contains("ormat") {
            return "".to_string();
        }
        if success {
            break code;
        }
        buffer_size *= 2;
    };

    if package {
        create_move_package(code.clone(), output_path);
    } else {
        fs::write(output_path, &code).expect("Failed to write the Move file");
    }

    let buffer_file_path = match package {
        true => output_path.join("buffer.raw"),
        false => output_path.with_extension("raw"),
    };
    fs::write(buffer_file_path, buffer).expect("Failed to write the raw buffer file");
    code
}
