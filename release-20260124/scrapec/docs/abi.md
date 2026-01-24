# ScrapeC ABI Stability and Cross-Language Linking

ScrapeC guarantees ABI stability for all exported functions and types marked as `extern` or `#[ffi]`.

- Compatible with C and Rust calling conventions
- Automatic header and FFI module generation
- Alignment, padding, and name mangling rules documented here

This document will be updated as the language evolves.
