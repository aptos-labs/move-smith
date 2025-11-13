use crate::{
    execution::{Report, ReportFormat},
    utils::create_tmp_move_file,
};
use clap::ValueEnum;
use log::error;
#[cfg(feature = "git_deps")]
use move_model::metadata::LanguageVersion;
#[cfg(feature = "legacy_deps")]
use move_model_legacy::metadata::LanguageVersion;
#[cfg(feature = "local_deps")]
use move_model_local::metadata::LanguageVersion;
#[cfg(feature = "git_deps")]
use move_transactional_test_runner::vm_test_harness::TestRunConfig;
#[cfg(feature = "legacy_deps")]
use move_transactional_test_runner_legacy::vm_test_harness::TestRunConfig;
#[cfg(feature = "local_deps")]
use move_transactional_test_runner_local::{tasks::SyntaxChoice, vm_test_harness::TestRunConfig};
#[cfg(feature = "git_deps")]
use move_vm_runtime::config::VMConfig;
#[cfg(feature = "legacy_deps")]
use move_vm_runtime_legacy::config::VMConfig;
#[cfg(feature = "local_deps")]
use move_vm_runtime_local::config::VMConfig;
use std::{collections::BTreeSet, path::PathBuf};
use tempfile::TempDir;

#[derive(Default, Clone)]
pub enum ExecutionMode {
    V1Only,
    V2Only,
    #[default]
    V1V2Comparison,
}

// #[derive(Default, Clone, Debug)]
// pub enum V2Setting {
//     #[default]
//     Optimization,
//     NoOptimization,
//     ExtraOptimization,
//     OptNoSimp,
//     NoV3Ref,
// }

#[derive(Clone, Debug)]
pub struct V2Setting {
    pub optimize: bool,
    pub optimize_extra: bool,
    pub ast_simplify: bool,
    pub acquires_check: bool,
    pub reference_safety_v3: bool,
    pub inline_optimization: bool,
}

impl Default for V2Setting {
    fn default() -> Self {
        Self {
            optimize: true,
            optimize_extra: false,
            ast_simplify: true,
            acquires_check: true,
            reference_safety_v3: true,
            inline_optimization: false,
        }
    }
}

impl V2Setting {
    pub fn to_experiments(&self) -> Vec<(String, bool)> {
        vec![
            ("optimize".to_string(), self.optimize),
            ("optimize-extra".to_string(), self.optimize_extra),
            ("ast-simplify".to_string(), self.ast_simplify),
            ("acquires-check".to_string(), self.acquires_check),
            ("reference-safety-v3".to_string(), self.reference_safety_v3),
            (
                "inlining-optimization".to_string(),
                self.inline_optimization,
            ),
        ]
    }

    pub fn opt() -> Self {
        Self {
            optimize: true,
            optimize_extra: false,
            ast_simplify: true,
            acquires_check: true,
            reference_safety_v3: true,
            inline_optimization: false,
        }
    }

    pub fn no_opt() -> Self {
        Self {
            optimize: false,
            optimize_extra: false,
            ast_simplify: true,
            acquires_check: false,
            reference_safety_v3: true,
            inline_optimization: false,
        }
    }

    pub fn extra_opt() -> Self {
        Self {
            optimize: true,
            optimize_extra: true,
            ast_simplify: true,
            acquires_check: true,
            reference_safety_v3: true,
            inline_optimization: false,
        }
    }
}
#[derive(Clone)]
pub struct RunConfig {
    pub mode: ExecutionMode,
    pub v2_setting: Option<V2Setting>,
    pub vm_config: Option<VMConfig>,
}

impl RunConfig {
    pub fn to_test_framework_config(&self) -> TestRunConfig {
        let experiments = match &self.v2_setting {
            Some(setting) => setting.to_experiments(),
            None => vec![],
        };
        #[cfg(feature = "legacy_deps")]
        {
            match &self.mode {
                ExecutionMode::V1Only => TestRunConfig::CompilerV1,
                ExecutionMode::V2Only => TestRunConfig::CompilerV2 {
                    language_version: LanguageVersion::V2_2,
                    v2_experiments: experiments,
                    vm_config: None,
                },
                ExecutionMode::V1V2Comparison => TestRunConfig::ComparisonV1V2 {
                    language_version: LanguageVersion::V2_1,
                    v2_experiments: experiments,
                    vm_config: None,
                },
            }
        }

        #[cfg(not(feature = "legacy_deps"))]
        {
            if matches!(
                self.mode,
                ExecutionMode::V1Only | ExecutionMode::V1V2Comparison
            ) {
                error!("V1 is not supported in the new test framework");
                panic!();
            }

            let mut vm_config = self.vm_config.clone().unwrap_or(VMConfig::default());
            vm_config.paranoid_type_checks = true;
            TestRunConfig {
                language_version: LanguageVersion::V2_2,
                experiments,
                vm_config,
                use_masm: false,
                echo: false,
                cross_compilation_targets: BTreeSet::new(),
                tracing: false,
            }
            // .cross_compile_into(SyntaxChoice::ASM, true, None)
            // .cross_compile_into(SyntaxChoice::Source, true, None)
        }
    }
}

#[derive(ValueEnum, Debug, Clone, Default)]
pub enum CommonRunConfig {
    V2Only,
    V1V2Comparison,
    #[default]
    V2OptLevels,
    V2Extra,
    DynRefCheck,
    InlineOpt,
}

impl CommonRunConfig {
    pub fn to_run_configs(&self) -> Vec<RunConfig> {
        use CommonRunConfig::*;
        match self {
            V2Only => vec![RunConfig {
                mode: ExecutionMode::V2Only,
                v2_setting: Some(V2Setting::opt()),
                vm_config: None,
            }],
            V1V2Comparison => vec![RunConfig {
                mode: ExecutionMode::V1V2Comparison,
                v2_setting: Some(V2Setting::opt()),
                vm_config: None,
            }],
            V2OptLevels => vec![
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::no_opt()),
                    vm_config: None,
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::opt()),
                    vm_config: None,
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::extra_opt()),
                    vm_config: None,
                },
            ],
            V2Extra => vec![RunConfig {
                mode: ExecutionMode::V2Only,
                v2_setting: Some(V2Setting::extra_opt()),
                vm_config: None,
            }],
            DynRefCheck => vec![
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::opt()),
                    vm_config: {
                        let mut config = VMConfig::default();
                        config.paranoid_ref_checks = false;
                        Some(config)
                    },
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::opt()),
                    vm_config: {
                        let mut config = VMConfig::default();
                        config.paranoid_ref_checks = true;
                        Some(config)
                    },
                },
            ],
            InlineOpt => vec![
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some({
                        let mut setting = V2Setting::opt();
                        setting.inline_optimization = true;
                        setting
                    }),
                    vm_config: None,
                },
                RunConfig {
                    mode: ExecutionMode::V2Only,
                    v2_setting: Some(V2Setting::opt()),
                    vm_config: None,
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
    pub work_dir: Option<PathBuf>,
}

#[derive(Default)]
pub struct TransactionalInputBuilder {
    file: Option<PathBuf>,
    code: String,
    runs: Vec<RunConfig>,
    work_dir: Option<PathBuf>,
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
        self.runs.push(RunConfig {
            mode,
            v2_setting,
            vm_config: None,
        });
        self
    }

    pub fn set_report_file(&mut self, file: PathBuf) -> &mut Self {
        self.file = Some(file);
        self
    }

    pub fn set_work_dir(&mut self, work_dir: PathBuf) -> &mut Self {
        self.work_dir = Some(work_dir);
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
            work_dir: self.work_dir.clone(),
        }
    }
}

impl Report for TransactionalInput {
    fn clean(&mut self) {
        self.code = "".to_string();
        self.runs.clear();
    }

    fn to_report(&self, _format: &ReportFormat) -> String {
        match &self.file {
            Some(file) => format!("{}", file.to_string_lossy()),
            None => "".to_string(),
        }
    }
}

impl TransactionalInput {
    pub fn get_file_path(&self) -> (PathBuf, Option<TempDir>) {
        match &self.work_dir {
            Some(work_dir) => {
                std::fs::create_dir_all(work_dir).unwrap();

                let filename = self
                    .file
                    .as_ref()
                    .and_then(|f| f.file_name())
                    .and_then(|name| name.to_str())
                    .unwrap_or("temp.move");

                let file_path = work_dir.join(filename);
                std::fs::write(&file_path, &self.code).unwrap();
                (file_path, None)
            },
            None => {
                let (file_path, temp_dir) = create_tmp_move_file(&self.code, None);
                (file_path, Some(temp_dir))
            },
        }
    }
}
