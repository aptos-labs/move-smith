use crate::{
    config::{CompilerSetting, GenerationConfig},
    runner::TransactionalTestError,
    utils::{compile_move_code, create_move_package},
    CodeGenerator, MoveSmith,
};
use arbitrary::Unstructured;
use derive_builder::Builder;
use indicatif::{ProgressBar, ProgressStyle};
use rand::{rngs::StdRng, Rng, SeedableRng};
use serde::Serialize;
use std::{
    collections::BTreeMap,
    fs,
    path::PathBuf,
    time::{Duration, Instant},
};

const BUFFER_SIZE_START: usize = 1024 * 16;

#[derive(Debug, Clone, Builder, Default)]
#[builder(setter(into, strip_option), default)]
pub struct TaskResult {
    pub success: bool,
    pub log: String,
    pub duration: Duration,
}

#[derive(Debug, Clone, Serialize)]
pub struct CheckReportError {
    pub v1: Vec<String>,
    pub v2: Vec<String>,
    pub files: Vec<PathBuf>,
}

#[derive(Debug, Clone, Serialize, Default)]
pub struct CheckReport {
    pub new: BTreeMap<String, CheckReportError>,
    pub ignored: BTreeMap<String, CheckReportError>,
}

impl CheckReportError {
    pub fn from_transactional_error(files: &[PathBuf], e: &TransactionalTestError) -> Self {
        Self {
            v1: e.v1_errors.iter().map(|e| e.0.clone()).collect(),
            v2: e.v2_errors.iter().map(|e| e.0.clone()).collect(),
            files: files.to_vec(),
        }
    }
}

pub fn raw2move(conf: &GenerationConfig, bytes: &[u8]) -> (TaskResult, String) {
    let mut u = Unstructured::new(bytes);

    let timer = Instant::now();
    let mut smith = MoveSmith::new(conf);
    match smith.generate(&mut u) {
        Ok(_) => (),
        Err(e) => {
            return (
                TaskResultBuilder::default()
                    .success(false)
                    .log(format!("MoveSmith failed to generate code:\n{:?}", e))
                    .duration(timer.elapsed())
                    .build()
                    .unwrap(),
                "".to_string(),
            );
        },
    };

    let code = smith.get_compile_unit().emit_code();
    (
        TaskResultBuilder::default()
            .success(true)
            .log("Parsed raw input successfully")
            .duration(timer.elapsed())
            .build()
            .unwrap(),
        code,
    )
}

pub fn generate_seeds(seed: u64, num: u64) -> Vec<u64> {
    let mut rng = rand::rngs::StdRng::seed_from_u64(seed);
    (0..num).map(|_| rng.gen()).collect()
}

/// If `package` is true, the `output_path` should be the path to the `.move` file.
/// If `package` is false, the `output_path` should be the path to the directory where the package will be saved.
pub fn generate_move_with_seed(
    conf: &GenerationConfig,
    output_path: &PathBuf,
    seed: u64,
    package: bool,
) -> (TaskResult, String) {
    let mut rng = StdRng::seed_from_u64(seed);
    let mut buffer_size = BUFFER_SIZE_START;
    let mut buffer = vec![];
    let timer = Instant::now();
    let code = loop {
        if buffer_size > buffer.len() {
            let diff = buffer_size - buffer.len();
            let mut new_buffer = vec![0u8; diff];
            rng.fill(&mut new_buffer[..]);
            buffer.extend(new_buffer);
        }
        let (r, code) = raw2move(conf, &buffer);
        if r.log.contains("ormat") {
            return (r, "".to_string());
        }
        if r.success {
            break code;
        }
        buffer_size *= 2;
    };
    let duration = timer.elapsed();

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
    (
        TaskResultBuilder::default()
            .success(true)
            .log(format!(
                "Generated MoveSmith instance with {} bytes in {}ms",
                buffer_size,
                duration.as_millis()
            ))
            .duration(duration)
            .build()
            .unwrap(),
        code,
    )
}

pub fn get_progress_bar_with_msg(num: u64, msg: &str) -> ProgressBar {
    let pb = ProgressBar::new(num);
    let style = ProgressStyle::default_bar()
        .progress_chars("=>-")
        .template(
            "{spinner:.green} {msg:.green} [{elapsed_precise}] [{bar:.cyan/blue}] {pos}/{len} (eta: {eta})",
        );
    pb.set_message(msg);
    pb.set_style(style);
    pb
}

pub fn set_v2_experiments(setting: &CompilerSetting) {
    let mut feats = vec![];
    for feat in setting.enable.iter() {
        feats.push(format!("{}=on", feat));
    }
    for feat in setting.disable.iter() {
        feats.push(format!("{}=off", feat));
    }
    let feats_value = feats.join(",");
    std::env::set_var("MVC_EXP", feats_value);
}

pub fn compile_move_code_with_setting(
    code: &str,
    setting: &CompilerSetting,
    v2: bool,
) -> TaskResult {
    let version = if v2 { "v2" } else { "v1" };
    set_v2_experiments(setting);
    let timer = Instant::now();
    let result = std::panic::catch_unwind(|| compile_move_code(code.to_string(), !v2, v2));

    let mut ret = TaskResultBuilder::default();
    let duration = timer.elapsed();
    ret.duration(duration);

    match result {
        Ok(true) => ret.success(true).log(format!(
            "Successfully compiled with {} in {}ms",
            version,
            duration.as_millis()
        )),
        Ok(false) => ret.success(false).log(format!(
            "Failed to compile with {} in {}ms",
            version,
            duration.as_millis(),
        )),
        Err(e) => ret
            .success(false)
            .log(format!("Paniced during {} compilation:\n{:?}", version, e)),
    };
    ret.build().unwrap()
}
