// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! The commend line interface for the MoveSmith fuzzer and auxiliary tools.

use move_smith::cli::{
    check::handle_check, compile::handle_compile, generate::handle_generate,
    raw2move::handle_raw2move, run::handle_run, Command, MoveSmithEnv,
};

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
