use indicatif::{ProgressBar, ProgressStyle};

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
