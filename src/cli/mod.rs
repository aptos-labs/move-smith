pub mod check;
pub mod common;
pub mod compile;
pub mod generate;
pub mod raw2move;
pub mod run;

use crate::{
    config::Config,
    execution::{transactional::CommonRunConfig, ReportFormat},
};
use clap::{ArgGroup, Args, Parser, Subcommand, ValueEnum};
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[command(name = "move-smith")]
#[command(about = "A CLI for the move-smith tool", version = "0.1.0")]
pub struct Cli {
    #[command(flatten)]
    pub global_options: GlobalOptions,
    #[command(subcommand)]
    pub command: Command,
}

#[derive(Args, Debug)]
pub struct GlobalOptions {
    #[arg(
        long,
        short,
        value_name = "CONFIG_FILE",
        default_value = "MoveSmith.toml"
    )]
    pub config: PathBuf,
    #[arg(long, short, value_name = "NUM_JOBS", default_value_t = default_jobs())]
    pub jobs: usize,
    /// Which execution mode and compiler configuration to use
    #[arg(long)]
    pub run: Option<CommonRunConfig>,
}

fn default_jobs() -> usize {
    let num_cores = num_cpus::get();
    std::cmp::max((num_cores as f64 * 0.8).floor() as usize, 1)
}

#[derive(Subcommand, Debug)]
pub enum Command {
    Run(Run),
    Compile(Compile),
    Raw2move(Raw2move),
    Generate(Generate),
    Fuzz(Fuzz),
    Cov(Cov),
    Check(Check),
}

/// Run a Move file or raw input file as a transactional test
#[derive(Args, Debug)]
pub struct Run {
    /// The Move file or raw input file to run
    #[arg(value_name = "FILE")]
    pub file: String,
    /// Run with all configurations
    #[arg(default_value = "false", long)]
    pub run_all: bool,
    /// Format to show the output
    #[arg(
        value_name = "OUTPUT_MODE",
        short,
        long,
        default_value = "canonicalized"
    )]
    pub output: OutputMode,
}

#[derive(ValueEnum, Debug, Clone)]
pub enum OutputMode {
    None,
    Canonicalized,
    Raw,
    Split,
}

#[derive(Args, Debug)]
pub struct Compile {
    #[arg(value_name = "FILE")]
    pub file: String,
    #[arg(long, default_value = "false")]
    pub no_v1: bool,
    #[arg(long, default_value = "false")]
    pub no_v2: bool,
}

#[derive(Args, Debug)]
#[clap(group = ArgGroup::new("input").required(true).args(&["raw_file", "stdin"]))]
pub struct Raw2move {
    #[arg(value_name = "RAW_FILE", group = "input")]
    pub raw_file: Option<PathBuf>,
    #[arg(long, group = "input")]
    pub stdin: bool,
    #[arg(long, short = 'p')]
    pub save_as_package: Option<PathBuf>,
}

#[derive(Args, Debug)]
pub struct Generate {
    #[arg(value_name = "NUM_FILES")]
    pub num: u64,
    #[arg(long, short, default_value = "1234")]
    pub seed: u64,
    #[arg(long, short, default_value = "false")]
    pub package: bool,
    #[arg(long, short, default_value = "output")]
    pub output_dir: PathBuf,
    #[arg(long)]
    pub skip_run: bool,
    #[arg(long)]
    pub ignore_error: bool,
}

#[derive(Args, Debug)]
pub struct Fuzz {
    #[arg(value_name = "TARGET_NAME")]
    pub target_name: String,
    #[arg(long, short, default_value = "24")]
    pub total_hours: i32,
    #[arg(long, default_value = "8")]
    pub init_corpus_size_kb: i32,
}

#[derive(Args, Debug)]
pub struct Cov {
    #[arg(value_name = "TARGET_NAME")]
    pub target_name: String,
    #[arg(value_name = "CORPUS_DIR")]
    pub corpus_dir: PathBuf,
}

#[derive(Args, Debug)]
pub struct Check {
    #[arg(value_name = "CORPUS_DIR")]
    pub corpus_dir: PathBuf,
    #[arg(short, long, default_value = "reports")]
    pub output_dir: PathBuf,
    #[arg(short, long, default_value = "text")]
    pub format: ReportFormat,
    /// Ignore the files whose name contains any of the given strings
    #[arg(short, long, default_value = "timeout")]
    pub ignore: Vec<String>,
    /// Regenerate the Move file from the raw input even if it already exists
    #[arg(long, default_value = "false")]
    pub regenerate: bool,
    /// Re-run the Move file even if an `.output` or `.error` file already exists
    #[arg(long, default_value = "false")]
    pub rerun: bool,
}

#[derive(Debug)]
pub struct MoveSmithEnv {
    pub cli: Cli,
    pub config: Config,
}

impl MoveSmithEnv {
    pub fn from_cli() -> Self {
        let cli = Cli::parse();
        let config = Config::from_toml_file_or_default(&cli.global_options.config);
        MoveSmithEnv { cli, config }
    }
}
