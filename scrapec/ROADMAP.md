# ScrapeC Development Roadmap

This roadmap outlines the step-by-step plan to develop ScrapeC into a production-ready, modern systems language.

## Phase 1: Core Infrastructure
- [x] Lexer
- [x] Parser
- [x] AST
- [x] Module scaffolding for all major features
- [ ] Type checker and inference engine
- [ ] Code generation (C/LLVM IR)
- [ ] Minimal runtime and standard library

## Phase 2: Language Features
- [ ] Ownership, borrowing, and lifetimes
- [ ] Pattern matching and algebraic data types
- [ ] Traits, generics, and type classes
- [ ] Macros and metaprogramming
- [ ] Async/await and concurrency
- [ ] Smart pointers and collections
- [ ] Unsafe/low-level features
- [ ] FFI (C and Rust)

## Phase 3: Tooling
- [ ] Package manager (`scrapec-pkg`)
- [ ] Language server (`scrapec-ls`)
- [ ] Documentation and test integration
- [ ] Hot code reloading

## Phase 4: Polish and Production
- [ ] Full test suite
- [ ] Performance optimization
- [ ] ABI stability and cross-language linking
- [ ] Comprehensive documentation
- [ ] Community and contribution guidelines

---

Each phase will be tracked and updated as features are implemented. See the `src/` directory for current progress.
