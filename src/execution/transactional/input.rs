use crate::{
    execution::{Report, ReportFormat},
    utils::create_tmp_move_file,
};
use clap::ValueEnum;
#[cfg(feature = "git_deps")]
use move_model::metadata::LanguageVersion;
#[cfg(feature = "local_deps")]
use move_model_local::metadata::LanguageVersion;
#[cfg(feature = "git_deps")]
use move_transactional_test_runner::vm_test_harness::TestRunConfig;
#[cfg(feature = "local_deps")]
use move_transactional_test_runner_local::vm_test_harness::TestRunConfig;
use std::path::PathBuf;
use tempfile::TempDir;

#[derive(Default, Clone)]
pub enum ExecutionMode {
    V1Only,
    V2Only,
    #[default]
    V1V2Comparison,
}

#[derive(Default, Clone)]
pub enum V2Setting {
    #[default]
    Optimization,
    NoOptimization,
    OptNoSimp,
}

impl V2Setting {
    pub fn to_expriments(&self) -> Vec<(String, bool)> {
        match self {
            Self::Optimization => vec![("optimize".to_string(), true)],
            Self::NoOptimization => vec![
                ("optimize".to_string(), false),
                ("acquires-check".to_string(), false),
            ],
            Self::OptNoSimp => vec![
                ("optimize".to_string(), true),
                ("ast-simplify".to_string(), false),
                ("acquires-check".to_string(), false),
            ],
        }
    }
}
#[derive(Clone)]
pub struct RunConfig {
    pub mode: ExecutionMode,
    pub v2_setting: Option<V2Setting>,
}

impl RunConfig {
    pub fn to_test_framework_config(&self) -> TestRunConfig {
        let v2_experiments = match &self.v2_setting {
            Some(setting) => setting.to_expriments(),
            None => vec![],
        };
        match &self.mode {
            ExecutionMode::V1Only => TestRunConfig::CompilerV1,
            ExecutionMode::V2Only => TestRunConfig::CompilerV2 {
                language_version: LanguageVersion::V2_0,
                v2_experiments,
            },
            ExecutionMode::V1V2Comparison => TestRunConfig::ComparisonV1V2 {
                language_version: LanguageVersion::V2_0,
                v2_experiments,
            },
        }
    }
}

#[derive(ValueEnum, Debug, Clone, Default)]
pub enum CommonRunConfig {
    #[default]
    V1V2Comparison,
    V2OptNoOpt,
    All,
}

impl CommonRunConfig {
    pub fn to_run_configs(&self) -> Vec<RunConfig> {
        use CommonRunConfig::*;
        match self {
            V1V2Comparison => vec![RunConfig {
                mode: ExecutionMode::V1V2Comparison,
                v2_setting: Some(V2Setting::Optimization),
            }],
            V2OptNoOpt => vec![
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::Optimization),
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::NoOptimization),
                },
            ],
            All => vec![
                RunConfig {
                    mode: ExecutionMode::V1Only,
                    v2_setting: None,
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::Optimization),
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::NoOptimization),
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::OptNoSimp),
                },
            ],
        }
    }
}

#[derive(Clone)]
pub struct TransactionalInput {
    pub file: Option<PathBuf>,
    pub code: String,
    pub runs: Vec<RunConfig>,
}

#[derive(Default)]
pub struct TransactionalInputBuilder {
    file: Option<PathBuf>,
    code: String,
    runs: Vec<RunConfig>,
}

impl TransactionalInputBuilder {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn load_code_from_file(&mut self, file: PathBuf) -> &mut Self {
        let code = std::fs::read_to_string(&file).unwrap();
        self.code = code;
        self.file = Some(file);
        self
    }

    pub fn set_code(&mut self, code: &str) -> &mut Self {
        self.code = code.to_string();
        self
    }

    pub fn with_default_run(&mut self) -> &mut Self {
        self.with_common_runs(&CommonRunConfig::default());
        self
    }

    pub fn with_common_runs(&mut self, config: &CommonRunConfig) -> &mut Self {
        self.runs.extend(config.to_run_configs());
        self
    }

    pub fn add_run(&mut self, mode: ExecutionMode, v2_setting: Option<V2Setting>) -> &mut Self {
        self.runs.push(RunConfig { mode, v2_setting });
        self
    }

    pub fn set_report_file(&mut self, file: PathBuf) -> &mut Self {
        self.file = Some(file);
        self
    }

    pub fn build(&mut self) -> TransactionalInput {
        if self.runs.is_empty() {
            self.with_default_run();
        }
        TransactionalInput {
            file: self.file.clone(),
            code: self.code.clone(),
            runs: self.runs.clone(),
        }
    }
}

impl Report for TransactionalInput {
    fn to_report(&self, _format: &ReportFormat) -> String {
        match &self.file {
            Some(file) => format!("{}", file.to_string_lossy()),
            None => "".to_string(),
        }
    }
}

impl TransactionalInput {
    pub fn get_file_path(&self) -> (PathBuf, TempDir) {
        create_tmp_move_file(&self.code, None)
    }
}
