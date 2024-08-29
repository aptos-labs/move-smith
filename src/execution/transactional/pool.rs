use crate::{
    config::CompilerSetting,
    execution::{transactional::TransactionalResult, ResultPool},
    utils::create_tmp_move_file,
};
use anyhow::Result;
use log::error;
#[cfg(feature = "git_deps")]
use move_model::metadata::LanguageVersion;
#[cfg(feature = "local_deps")]
use move_model_local::metadata::LanguageVersion;
#[cfg(feature = "git_deps")]
use move_transactional_test_runner::{vm_test_harness, vm_test_harness::TestRunConfig};
#[cfg(feature = "local_deps")]
use move_transactional_test_runner_local::{vm_test_harness, vm_test_harness::TestRunConfig};
use once_cell::sync::Lazy;
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::{
    collections::BTreeSet,
    error::Error,
    fmt::Display,
    panic,
    path::PathBuf,
    time::{Duration, Instant},
};
use tempfile::TempDir;

pub struct TransactionalResultPool;

impl ResultPool for TransactionalResultPool {
    type ResultType = TransactionalResult;

    fn add_result(&mut self, result: Self::ResultType) {
        unimplemented!()
    }

    fn should_ignore(&self, result: &Self::ResultType) -> bool {
        unimplemented!()
    }
}
