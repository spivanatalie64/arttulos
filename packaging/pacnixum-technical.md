# PacNixum Engine: Technical Overview

## Introduction
PacNixum is a next-generation package manager designed to unify the best features of RHEL (YUM/DNF), Arch (Pacman), and Nix. It enables seamless installation and management of packages from all three ecosystems, with atomic transactions and reproducible builds.

---

## Architecture
- **Layered Backends:**
  - `--layer=rhel` for RHEL/CentOS/Alma/Rocky RPMs (via DNF/YUM backend)
  - `--layer=arch` for Arch/AUR packages (via Pacman backend)
  - `--layer=nix` for Nix/NixOS flakes and packages
- **Atomic Transactions:**
  - All package operations are atomic and can be rolled back instantly
- **Unified CLI:**
  - Consistent command structure for all backends

---

## Example Commands
```sh
# Install a package from RHEL repo
pacnixum install --layer=rhel postgresql

# Install a package from Arch repo
pacnixum install --layer=arch neovim

# Install a Nix flake
pacnixum install --layer=nix github:nixos/nixpkgs#htop

# Roll back the last transaction
pacnixum rollback
```

---

## Key Features
- **Multi-ecosystem support:** Use RPM, Arch, and Nix packages side-by-side
- **Reproducibility:** All installs are tracked and can be rolled back
- **Speed:** Parallel downloads and optimized dependency resolution
- **Security:** Verifies signatures and checksums for all sources
- **Declarative Config:** Supports system configuration via Nix flakes

---

## Integration
- PacNixum is the default package manager for ArttulOS
- System generations and rollbacks are managed via PacNixum snapshots
- Compatible with both CLI and GUI frontends

---

## Contributing
See the `packaging/` directory for source code, design docs, and contribution guidelines.
