# PacNixum Core Feature Checklist

This document lists the essential features and components required for PacNixum to be a fully functional, unified package manager for ArttulOS.

## 1. Command-Line Interface (CLI)
- [ ] Argument parsing and help output
- [ ] Subcommands: install, remove, update, search, info, rollback, etc.
- [ ] Layer selection: --layer=rhel, --layer=arch, --layer=nix

## 2. Backend Integration
- [ ] RHEL backend: install/remove RPMs (via DNF/YUM or FFI)
- [ ] Arch backend: install/remove packages (via Pacman or FFI)
- [ ] Nix backend: install/remove flakes/packages (via Nix CLI or FFI)
- [ ] Unified transaction and rollback system

## 3. Package Database & State
- [ ] Track installed packages and versions
- [ ] Atomic transaction log and rollback support
- [ ] System snapshot/restore integration

## 4. Networking & Downloads
- [ ] Download packages and metadata (optional networking)
- [ ] Mirror selection and failover
- [ ] Signature and checksum verification

## 5. Configuration & Logging
- [ ] Config file parsing (YAML/TOML/JSON)
- [ ] Logging (info, warning, error)
- [ ] User prompts and confirmations

## 6. Error Handling & Recovery
- [ ] Robust error reporting
- [ ] Recovery from failed transactions
- [ ] Diagnostic and debug output

## 7. Documentation & Tests
- [ ] User and developer documentation
- [ ] Unit and integration tests
- [ ] Example scripts and usage

---

This checklist will be updated as features are implemented. See the source code and docs for current progress.
