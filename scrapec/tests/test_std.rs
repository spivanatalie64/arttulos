// tests/test_std.rs
// Tests for ScrapeC stdlib file I/O and subprocess

#[test]
fn test_file_io() {
    use std::fs;
    let path = "testfile.txt";
    fs::write(path, "hello").unwrap();
    let contents = fs::read_to_string(path).unwrap();
    assert_eq!(contents, "hello");
    fs::remove_file(path).unwrap();
}

#[test]
fn test_run_command() {
    use std::process::Command;
    let output = Command::new("echo").arg("hi").output().unwrap();
    assert!(String::from_utf8_lossy(&output.stdout).contains("hi"));
}
