// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! The commend line interface for the MoveSmith fuzzer and auxiliary tools.

use core::panic;
use glob::glob;
use indicatif::{HumanDuration, ParallelProgressIterator};
use move_smith::{
    cli::{
        common::{
            compile_move_code_with_setting, generate_move_with_seed, generate_seeds,
            get_progress_bar_with_msg, raw2move, CheckReport, CheckReportError,
        },
        Check, Command, Compile, Generate, MoveSmithEnv, Raw2move, Run,
    },
    runner::{Runner, TransactionalResult},
    utils::create_move_package,
};
use rayon::prelude::*;
use std::{
    collections::BTreeMap,
    fs,
    io::{stdin, Read},
    path::{Path, PathBuf},
    time::Instant,
};

fn handle_check(env: &MoveSmithEnv, cmd: &Check) {
    let runner = Runner::new_with_known_errors(&env.config.fuzz, true);
    println!("[1/3] Reloaded known errors...");

    let corpus_dir = Path::new(&cmd.corpus_dir);
    println!("Checking corpus dir: {:?}", corpus_dir);
    if !corpus_dir.exists() {
        panic!("Corpus dir does not exist");
    }

    let mut all_inputs = vec![];
    let patterns = ["crash*", "oom*"];
    for pattern in &patterns {
        let search_pattern = format!("{}/**/{}", corpus_dir.display(), pattern);
        for entry in glob(&search_pattern).expect("Failed to read glob pattern") {
            match entry {
                Ok(path) => all_inputs.push(path),
                Err(e) => println!("{:?}", e),
            }
        }
    }
    println!("[2/3] Found {} crashing input files", all_inputs.len());

    let pb = get_progress_bar_with_msg(all_inputs.len() as u64, "Checking");
    let timer = Instant::now();
    let results = all_inputs
        .par_iter()
        .map(|input_file| {
            let bytes = fs::read(input_file).unwrap();
            let (r, code) = raw2move(&env.config.generation, &bytes);
            let code = {
                if !r.success {
                    pb.println(format!(
                        "Failed to convert raw bytes for {}",
                        input_file.display()
                    ));
                    pb.inc(1);
                    return vec![];
                }
                code
            };
            let results = runner.run_transactional_test(&code);
            pb.inc(1);
            results
        })
        .collect::<Vec<Vec<TransactionalResult>>>();
    pb.finish_and_clear();
    println!("[2/3] Executed {} crashing input files", all_inputs.len());

    let mut error_map = BTreeMap::new();
    for (input_file, results) in all_inputs.iter().zip(results.iter()) {
        for r in results.iter() {
            if let Err(err) = &r.result {
                let entry = error_map.entry(err).or_insert(vec![]);
                entry.push(input_file.clone());
            }
        }
    }
    let mut report = CheckReport::default();
    for (err, files) in error_map.iter() {
        let report_err = CheckReportError::from_transactional_error(files, err);
        if runner.error_pool.should_skip_error(err) {
            report
                .ignored
                .insert(format!("error-{:0>3}", report.ignored.len()), report_err);
        } else {
            report
                .new
                .insert(format!("error-{:0>3}", report.new.len()), report_err);
        }
    }
    println!(
        "[3/3] Clustered {} runs into {} new errors and {} ignored errors",
        all_inputs.len(),
        report.new.len(),
        report.ignored.len(),
    );
    let toml_str = toml::to_string_pretty(&report).expect("Failed to serialize report to TOML");
    fs::write(&cmd.output_file, toml_str).expect("Failed to write report file");
    println!("Saved report to: {:?}", cmd.output_file);
    println!("Done checking in {}", HumanDuration(timer.elapsed()));
}

fn handle_generate(env: &MoveSmithEnv, cmd: &Generate) {
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
        .progress_with(get_progress_bar_with_msg(cmd.num, "Generatin"))
        .map(|(file, seed)| {
            let (_, code) =
                generate_move_with_seed(&env.config.generation, file, *seed, cmd.package);
            code
        })
        .collect::<Vec<String>>();
    println!(
        "[1/2] Done generating {} Move files in {}",
        cmd.num,
        HumanDuration(timer.elapsed())
    );

    if !cmd.skip_run {
        println!("[2/2] Running transactional tests...");
        let runner = Runner::new_with_known_errors(&env.config.fuzz, false);
        let pb = get_progress_bar_with_msg(cmd.num, "Running");
        let timer = Instant::now();
        let results = codes
            .par_iter()
            .map(|code| {
                pb.inc(1);
                let results = runner.run_transactional_test(code);
                for r in results.iter() {
                    if !runner.error_pool.should_skip_result(r) {
                        return true;
                    }
                }
                false
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

fn handle_raw2move(env: &MoveSmithEnv, cmd: &Raw2move) {
    let bytes = match cmd.stdin {
        true => {
            let mut buffer = vec![];
            stdin().read_to_end(&mut buffer).unwrap();
            buffer
        },
        false => fs::read(cmd.raw_file.clone().unwrap()).unwrap(),
    };
    let (r, code) = raw2move(&env.config.generation, &bytes);
    if let Some(save_as) = &cmd.save_as_package {
        let save_as = PathBuf::from(save_as);
        create_move_package(code.clone(), &save_as);
        println!("Generated Move package in {}ms", r.duration.as_millis());
        println!("Saved as package at: {:?}", save_as);
    } else {
        println!("{}", code);
        println!("// Generated Move code in {}ms", r.duration.as_millis());
    }
}

fn handle_run(env: &MoveSmithEnv, cmd: &Run) {
    let code = match fs::read_to_string(&cmd.file) {
        Ok(s) => s.to_string(),
        Err(_) => {
            println!("Converting: {:?} to Move", cmd.file);
            let bytes = fs::read(&cmd.file).unwrap();
            let (r, code) = raw2move(&env.config.generation, &bytes);
            if !r.success {
                println!("Failed to convert raw bytes to Move code:\n{}", r.log);
                return;
            }
            code
        },
    };
    println!("Loaded code from file: {:?}", cmd.file);
    // let runner = Runner::new_with_known_errors(&env.config.fuzz, true);
    let runner = Runner::new(&env.config.fuzz);
    let results = runner.run_transactional_test(&code);
    for r in results.iter() {
        match r.result.is_ok() {
            true => println!("Success -- {}", r.description),
            false => println!("Failed -- {}", r.description),
        }
        if !cmd.silent {
            println!("{}", r.get_log());
            println!(
                "Will be ignored: {}",
                runner.error_pool.should_skip_result(r)
            );
        }
        println!(
            "Finished running transactional test in: {}ms",
            r.duration.as_millis()
        );
    }
    println!("Done!")
}

fn handle_compile(env: &MoveSmithEnv, cmd: &Compile) {
    let code = fs::read_to_string(&cmd.file).unwrap();
    println!("Loaded code from file: {:?}", cmd.file);

    let setting = env.config.get_compiler_setting(&cmd.use_setting).unwrap();
    println!(
        "Using fuzz.compiler_settings.{} from {}",
        cmd.use_setting,
        env.cli.global_options.config.display()
    );

    if cmd.no_v1 {
        println!("V1 compilation skipped.")
    } else {
        let r = compile_move_code_with_setting(&code, setting, false);
        println!("{}", r.log);
    }

    if cmd.no_v2 {
        println!("V2 compilation skipped.")
    } else {
        let r = compile_move_code_with_setting(&code, setting, true);
        println!("{}", r.log);
    }
    println!("Done!")
}

fn main() {
    env_logger::init();
    let env = MoveSmithEnv::from_cli();
    rayon::ThreadPoolBuilder::new()
        .num_threads(env.cli.global_options.jobs)
        .build_global()
        .unwrap();
    match &env.cli.command {
        Command::Run(cmd) => handle_run(&env, cmd),
        Command::Compile(cmd) => handle_compile(&env, cmd),
        Command::Generate(cmd) => handle_generate(&env, cmd),
        Command::Raw2move(cmd) => handle_raw2move(&env, cmd),
        Command::Check(cmd) => handle_check(&env, cmd),
        _ => unimplemented!(),
    }
}
