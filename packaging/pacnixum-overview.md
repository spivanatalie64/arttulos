# PacNixum Engine Overview

## Why choose PacNixum?

PacNixum allows you to install RHEL RPMs for your production database, Arch packages for your dev-environment, and Nix-flakes for your system config—all managed through a single, lightning-fast interface.

### Example Usage
```sh
# pacnixum install --layer=rhel postgresql
```

## Key Features
- Unified package management for RHEL, Arch, and Nix ecosystems
- Atomic, reproducible transactions
- Fast, user-friendly CLI
- Designed for both enterprise and power users

---

## Technical Details

See `pacnixum-technical.md` in this directory for a full technical breakdown, including architecture, example commands, and integration notes.

### Quick Reference
- **Install from RHEL repo:**
  ```sh
  pacnixum install --layer=rhel <package>
  ```
- **Install from Arch repo:**
  ```sh
  pacnixum install --layer=arch <package>
  ```
- **Install a Nix flake:**
  ```sh
  pacnixum install --layer=nix <flake>
  ```
- **Rollback:**
  ```sh
  pacnixum rollback
  ```

---

For more details, see the main documentation or contribute to the `packaging/` directory.
