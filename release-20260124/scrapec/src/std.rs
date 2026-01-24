// src/std.rs
// ScrapeC Minimal Standard Library (Expanding for Package Manager)

use std::fs;
use std::io::{self, Read, Write};
use std::process::{Command, Output};

pub fn print(msg: &str) {
    println!("{}", msg);
}

pub fn add(a: i64, b: i64) -> i64 {
    a + b
}

pub fn read_file(path: &str) -> io::Result<String> {
    fs::read_to_string(path)
}

pub fn write_file(path: &str, contents: &str) -> io::Result<()> {
    fs::write(path, contents)
}

pub fn run_command(cmd: &str, args: &[&str]) -> io::Result<Output> {
    Command::new(cmd).args(args).output()
}

#[cfg(feature = "networking")]
pub fn download_url(url: &str) -> Result<Vec<u8>, String> {
    let output = Command::new("curl").arg("-s").arg(url).output()
        .map_err(|e| format!("Failed to run curl: {}", e))?;
    if output.status.success() {
        Ok(output.stdout)
    } else {
        Err(format!("curl failed: {}", String::from_utf8_lossy(&output.stderr)))
    }
}

#[cfg(not(feature = "networking"))]
pub fn download_url(_url: &str) -> Result<Vec<u8>, String> {
    Err("Networking support is not enabled in this build.".to_string())
}

// Error handling and logging utilities
pub fn log_error(msg: &str) {
    eprintln!("[ERROR] {}", msg);
}

pub fn log_info(msg: &str) {
    println!("[INFO] {}", msg);
}

pub fn try_or_log<T, E: std::fmt::Display>(result: Result<T, E>, context: &str) -> Option<T> {
    match result {
        Ok(val) => Some(val),
        Err(e) => {
            log_error(&format!("{}: {}", context, e));
            None
        }
    }
}
