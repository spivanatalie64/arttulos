// PacNixum CLI (Rust prototype)
fn main() {
    println!("PacNixum (Rust) - Unified Package Manager Prototype");
    let args: Vec<String> = std::env::args().collect();
    println!("Args: {:?}", &args[1..]);
}
