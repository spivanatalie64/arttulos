# Why ScrapeC for PacNixum?

PacNixum is designed to be a next-generation, unified package manager for ArttulOS, requiring:
- High performance and low-level system access (like C)
- Memory safety, concurrency, and modern abstractions (like Rust)
- Seamless FFI with C and Rust for package backend integration
- Binary compatibility with existing Linux tools
- Rapid development, hot code reloading, and ergonomic syntax

ScrapeC is the only language that combines all these requirements:
- It offers the speed and portability of C, with the safety and expressiveness of Rust.
- Its FFI and ABI compatibility allow direct calls to RPM, Pacman, and Nix libraries.
- Its modern tooling and language features enable rapid, safe development of complex system utilities.
- ScrapeC is purpose-built for ArttulOS, ensuring long-term maintainability and innovation.

**In short:** ScrapeC is the only language that lets us build a package manager as powerful, safe, and flexible as PacNixum—without compromise.
