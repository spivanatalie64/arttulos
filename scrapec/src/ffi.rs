// src/ffi.rs
// ScrapeC FFI (Basic Implementation)

use std::ffi::CString;
use std::os::raw::c_char;

pub fn generate_c_header() -> String {
    "// C header for ScrapeC\nvoid main();\n".to_string()
}

pub fn generate_rust_mod() -> String {
    "// Rust extern mod for ScrapeC\nextern \"C\" { fn main(); }\n".to_string()
}

pub fn call_c_function() {
    // Example: call puts from libc
    unsafe {
        let msg = CString::new("Hello from ScrapeC via C FFI!\n").unwrap();
        libc::puts(msg.as_ptr() as *const c_char);
    }
}

#[no_mangle]
pub extern "C" fn rust_hello(name: *const c_char) {
    let c_str = unsafe { std::ffi::CStr::from_ptr(name) };
    if let Ok(name_str) = c_str.to_str() {
        println!("Hello from Rust, {}!", name_str);
    }
}

pub fn call_rust_function() {
    // Example: call a Rust function via FFI
    let name = CString::new("ScrapeC").unwrap();
    unsafe { rust_hello(name.as_ptr()); }
}
