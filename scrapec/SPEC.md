# ScrapeC Language Specification (Vision)

ScrapeC is a next-generation systems programming language, designed to be as fast and portable as C, as safe and expressive as Rust, and even more productive and ergonomic. It is the language for building the future of operating systems, embedded, and high-performance applications.

---


## 1. Syntax Overview
- C-like syntax (curly braces, semicolons, familiar keywords)
- Rust-style type inference and ownership
- Functions, structs, enums, modules
- Pattern matching (concise, exhaustive, and ergonomic)
- Immutability by default; `mut` for mutability
- No nulls, no undefined behavior


## 2. Types
- Primitive: `int`, `float`, `bool`, `char`, `str`
- Compound: `struct`, `enum`, `tuple`, `array`, `slice`
- References: `&T` (immutable), `&mut T` (mutable)
- Option and Result types for error handling
- Algebraic data types (sum and product types)
- Type inference everywhere (explicit types optional)


## 3. Memory Safety
- Ownership and borrowing rules (no data races, no use-after-free)
- Automatic memory management (no GC, but deterministic drop)
- Lifetimes are inferred in most cases
- No manual memory management required, but possible for experts


## 4. Concurrency
- `thread::spawn` for lightweight threads
- Channels for message passing
- Mutex and atomic types
- First-class async/await and actor model
- Safe parallelism by default



## 5. Interoperability & Binary Compatibility
- `extern` blocks for C and Rust FFI
- Seamless calling of C and Rust libraries
- **Binary compatibility:** ScrapeC variables and data structures use the same memory layout and calling conventions as C and Rust by default, enabling direct sharing of structs, enums, and primitive types across language boundaries.
- **Linking:** ScrapeC can statically or dynamically link to C and Rust libraries without wrappers or glue code.
- **ABI stability:** The ScrapeC compiler guarantees that exported functions and types marked as `extern` or `#[ffi]` are ABI-compatible with both C and Rust, including name mangling, alignment, and padding rules.
- **Header generation:** ScrapeC can auto-generate C headers (`.h`) and Rust FFI modules for seamless integration.


## 5.1 Example: C and Rust FFI

### Calling a C function from ScrapeC
```scrapec
extern "C" {
    fn puts(s: &str) -> int;
}

fn main() {
    puts("Hello from ScrapeC to C!\n");
}
```

### Calling a Rust function from ScrapeC
```scrapec
extern "Rust" {
    fn rust_hello(name: &str);
}

fn main() {
    rust_hello("ScrapeC");
}
```

### Exporting a ScrapeC function to C or Rust
```scrapec
#[ffi]
pub fn add(a: int, b: int) -> int {
    a + b
}
```

// The compiler will generate compatible C headers and Rust extern blocks automatically.


## 6. Example
```scrapec
fn main() {
    let x = 42;
    let y = 8;
    print!("{} + {} = {}\n", x, y, x + y);

    // Pattern matching
    let result = match (x, y) {
        (a, b) if a > b => Ok(a - b),
        (a, b) => Err("b >= a"),
    };

    // Async/await
    async fn fetch_data() -> Result<str, Error> {
        // ...
    }
}
```

---


## 7. Tooling
- Compiler: `scrapec` (to C, LLVM IR, or native code)
- Package manager: `scrapec-pkg` (faster and more reliable than Cargo)
- Language server: `scrapec-ls`
- Hot code reloading for rapid development

---


---

- Zero-cost abstractions, but with even simpler syntax than Rust
- Compile-time reflection and hygienic macros
- Hot code reloading for development
- No nulls, no undefined behavior, no data races
- Immutability by default, mutability opt-in
- Modern error handling (Result, Option, checked exceptions)
- Seamless FFI with C and Rust
- Best-in-class build and dependency management

## 8. Unique Selling Points
- Zero-cost abstractions, but with even simpler syntax than Rust
- Compile-time reflection and hygienic macros
- Hot code reloading for development
- No nulls, no undefined behavior, no data races
- Immutability by default, mutability opt-in
- Modern error handling (Result, Option, checked exceptions)
- Seamless FFI with C and Rust
- **Full binary compatibility with C and Rust variables, structs, and libraries**
- Best-in-class build and dependency management
- Zero-cost abstractions, but with even simpler syntax than Rust
- Compile-time reflection and hygienic macros
- Hot code reloading for development
- No nulls, no undefined behavior, no data races
- Immutability by default, mutability opt-in
- Modern error handling (Result, Option, checked exceptions)
- Seamless FFI with C and Rust
- Best-in-class build and dependency management

---

This is a living document. See `src/` for the reference implementation and evolving language features.

---

## 9. Complete Feature Set: C + Rust + More

ScrapeC aims to be a true superset of both C and Rust, supporting (or improving upon) every major feature of both languages:

### From C:
- Pointers and pointer arithmetic (with safety checks)
- Manual memory management (malloc/free), but with safe alternatives
- Structs, unions, enums (with tagged unions)
- Bitfields and packed structs
- Preprocessor macros (replaced by hygienic macros)
- Inline assembly
- Volatile and atomic types
- Function pointers and callbacks
- Variadic functions (with type safety)
- C standard library compatibility
- Header file generation and inclusion
- Platform-specific intrinsics

### From Rust:
- Ownership, borrowing, and lifetimes
- Pattern matching and algebraic data types
- Traits (type classes/interfaces)
- Generics and monomorphization
- Modules and privacy
- Macros (hygienic, procedural, and declarative)
- Type inference
- Option, Result, and error handling
- Immutability by default
- Concurrency: threads, async/await, channels, atomics
- Smart pointers (Box, Rc, Arc, etc.)
- Slices, iterators, and collections
- Unsafe blocks for low-level operations
- No nulls, no undefined behavior
- Modern build system and package manager
- Documentation comments and test integration
- Attribute system (#[derive], #[inline], etc.)
- FFI with C and Rust
- Hot code reloading (planned)

### ScrapeC Improvements:
- Even more ergonomic syntax
- Compile-time reflection and metaprogramming
- Safer pointer arithmetic and bounds checking
- Automatic header and FFI module generation
- Checked exceptions (optional)
- Hot code reloading for rapid development
- ABI stability and cross-language linking
- Best-in-class dependency management

---

**Feature Status:**
- [x] Lexing/parsing (basic)
- [ ] Type system (in progress)
- [ ] Code generation (planned)
- [ ] Full FFI (planned)
- [ ] Macros and metaprogramming (planned)
- [ ] Async/await and concurrency (planned)
- [ ] Smart pointers and collections (planned)
- [ ] Unsafe/low-level features (planned)
- [ ] Documentation/test integration (planned)

This section will be updated as features are implemented.
