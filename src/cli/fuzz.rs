// Copyright (c) Aptos Foundation
// SPDX-License-Identifier: Apache-2.0

//! The commend line interface for the MoveSmith fuzzer and auxiliary tools.

use crate::cli::Fuzz;
use rand::Rng;
use std::path::{Path, PathBuf};

pub struct SessionConfig {
    pub fuzz: Fuzz,
    pub log_dir: PathBuf,
    pub seed_dir: PathBuf,
}

pub trait Engine {
    fn run(&self, config: SessionConfig);
}

fn create_random_file(fpath: &Path, size: usize) -> Result<()> {
    let mut rng = rand::thread_rng();
    let mut random_bytes = vec![0u8; size];
    rng.fill(&mut random_bytes);
    unimplemented!();
}
