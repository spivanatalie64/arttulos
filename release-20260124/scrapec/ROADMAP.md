# ScrapeC Development Roadmap

This roadmap outlines the step-by-step plan to develop ScrapeC into a production-ready, modern systems language.

## Phase 1: Core Infrastructure
- [x] Lexer
- [x] Parser
- [x] AST
- [x] Module scaffolding for all major features
- [x] Type checker and inference engine (basic variable tracking and inference)
- [x] Code generation (basic C output for functions and variables)
- [x] Minimal runtime and standard library (stubs for runtime and stdlib)

## Phase 2: Language Features
- [x] Ownership, borrowing, and lifetimes (scaffolded)
- [x] Pattern matching and algebraic data types (scaffolded)
- [x] Traits, generics, and type classes (scaffolded)
- [x] Macros and metaprogramming (scaffolded)
- [x] Async/await and concurrency (scaffolded)
- [x] Smart pointers and collections (scaffolded)
- [x] Unsafe/low-level features (scaffolded)
- [x] FFI (C and Rust) (scaffolded)

## Phase 3: Tooling
- [x] Package manager (`scrapec-pkg`) (scaffolded)
- [x] Language server (`scrapec-ls`) (scaffolded)
- [x] Documentation and test integration (scaffolded)
- [x] Hot code reloading (scaffolded)

## Phase 4: Polish and Production
- [ ] Full test suite
- [ ] Performance optimization
- [ ] ABI stability and cross-language linking
- [ ] Comprehensive documentation
- [ ] Community and contribution guidelines

---

Each phase will be tracked and updated as features are implemented. See the `src/` directory for current progress.
