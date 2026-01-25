# Pacnixum Package Manager: Feature Roadmap

This document provides a detailed implementation roadmap for every feature and subcommand to be included in the ScrapeC-based package manager, based on the combined functionality of DNF5, Pacman, and Nix.


## 1. Core Package Operations

## 0. System Optimizations (ZFS & Network)

### 0.1 OpenZFS Integration & Optimization
- **Description:** Optimize package operations using OpenZFS features for speed and reliability.
- **User Story:** As a user, I want package installs, removals, and rollbacks to be fast and reliable using ZFS snapshots and parallelism.
- **Implementation Steps:**
  1. Use ZFS snapshots before/after package transactions for instant rollback.
  2. Parallelize ZFS dataset operations where safe (e.g., for independent datasets).
  3. Tune ZFS transaction group and cache settings for low-latency package operations.
  4. Batch file operations to minimize disk I/O.
- **Dependencies:** ZFS tools, system tuning, transaction engine.
- **Test/Validation:** Measure install/remove/rollback speed, verify snapshot/restore, test under load.

### 0.2 BSD Network Driver Compatibility Layer
- **Description:** Provide a compatibility layer to use BSD network drivers on this OS, with an option to disable Linux network drivers.
- **User Story:** As a user, I want to use superior BSD network drivers and a generic driver for all network interfaces.
- **Implementation Steps:**
  1. Integrate a kernel module or userspace layer to load BSD network drivers.
  2. Develop a generic network driver interface that abstracts hardware details and uses BSD code as backend.
  3. Disable Linux network driver modules at boot if BSD/generic driver is present.
  4. Ensure the generic driver can enumerate, configure, and manage all network interfaces.
- **Dependencies:** Kernel module, driver abstraction layer, hardware database.
- **Test/Validation:** Boot with only BSD/generic drivers, test all major network chipsets, verify fallback/notification for unsupported devices.

### 0.3 Pluggable Network Backend for Package Operations
- **Description:** Allow package manager and ZFS tools to select a network backend (BSD, generic, or Linux) at runtime or via config.
- **User Story:** As a user, I want package downloads, ZFS send/receive, and replication to work regardless of the underlying network driver stack.
- **Implementation Steps:**
  1. Abstract network operations in package manager and ZFS scripts/tools.
  2. Provide config/CLI option to select network backend.
  3. Test all operations with each backend.
- **Dependencies:** Network abstraction layer, ZFS tools, package manager.
- **Test/Validation:** Download/install packages, ZFS replication, and rollback using each backend.

### 1.1 Install Packages
- **Description:** Install one or more packages from repositories or local files.
- **User Story:** As a user, I want to install packages by name or file, with dependency resolution and optional flags.
- **Implementation Steps:**
  1. Parse package names/files from CLI.
  2. Query repositories for package metadata.
  3. Resolve dependencies (with user confirmation for optional deps).
  4. Download and verify packages.
  5. Install packages, run hooks, update database.
- **Dependencies:** Repo access, dependency resolver, transaction engine.
- **Test/Validation:** Install single/multiple packages, handle missing deps, verify rollback on failure.

### 1.2 Remove Packages
- **Description:** Remove installed packages, with options for cascading/removing unneeded deps.
- **User Story:** As a user, I want to remove packages and optionally their dependencies or config files.
- **Implementation Steps:**
  1. Parse package names from CLI.
  2. Check for reverse dependencies.
  3. Prompt for cascade/recursive removal if needed.
  4. Remove files, update database, run hooks.
- **Dependencies:** Database, dependency checker, file manager.
- **Test/Validation:** Remove single/multiple packages, cascade, handle protected packages.

### 1.3 Update/Upgrade Packages
- **Description:** Update package databases and upgrade installed packages.
- **User Story:** As a user, I want to update my system to the latest package versions.
- **Implementation Steps:**
  1. Sync package databases from all enabled repos.
  2. Check for upgradable packages.
  3. Present upgrade plan to user.
  4. Download, verify, and install upgrades.
- **Dependencies:** Repo sync, version checker, transaction engine.
- **Test/Validation:** Upgrade all, selective upgrade, handle conflicts.

### 1.4 Search Packages
- **Description:** Search for packages by name, description, or file ownership.
- **User Story:** As a user, I want to find packages matching a query or see which package owns a file.
- **Implementation Steps:**
  1. Parse search query from CLI.
  2. Search local and/or remote databases.
  3. Display results with relevant metadata.
- **Dependencies:** Database index, search engine.
- **Test/Validation:** Search by name, description, file, regex.

### 1.5 Query/Info/List
- **Description:** Query package info, list installed/available packages, show files, groups, etc.
- **User Story:** As a user, I want to see detailed info about packages, groups, and files.
- **Implementation Steps:**
  1. Parse query type and target from CLI.
  2. Fetch info from local/remote database.
  3. Format and display output.
- **Dependencies:** Database, formatter.
- **Test/Validation:** Info, list files, groups, changelogs, etc.


## 2. Advanced Features

---

# BSD Network Driver Compatibility Layer & Generic Driver (Scaffold)

## Overview
This OS will include a compatibility layer to load and use BSD network drivers, and a generic driver interface to support all network interfaces. Linux network drivers can be disabled if the generic/compatibility layer is present and functional.

## Components
- **bsdnet_compat.ko**: Kernel module or userspace loader for BSD network drivers.
- **gen_netif.ko**: Generic network interface driver, using BSD code as backend.
- **net_backend_selector**: Tool or config to select network backend (BSD, generic, Linux).

## Implementation Steps
1. Port BSD network driver code to a loadable module or userspace wrapper.
2. Develop a generic driver interface that can call BSD driver routines for all major chipsets.
3. Add boot logic to disable Linux network drivers if BSD/generic is present.
4. Expose a unified API to the OS networking stack.
5. Integrate with package manager and ZFS tools for network operations.

## Testing
- Boot with only BSD/generic drivers.
- Test all major network chipsets (wired, wireless, virtual).
- Verify package manager and ZFS network operations.

---

# OpenZFS Scripts & Packaging: Proposed Changes

1. Remove hardcoded Linux network driver dependencies from ZFS scripts.
2. Add detection logic for BSD/generic network backend in ZFS send/receive and replication scripts.
3. Batch and parallelize ZFS dataset operations in package manager integration scripts.
4. Use ZFS snapshots for all package transactions (install, remove, upgrade) for instant rollback.
5. Expose a config option to select network backend for ZFS and package manager operations.
6. Document all changes and provide migration instructions for users.

### 2.1 Transaction Rollback
- **Description:** Roll back failed or partial transactions.
- **User Story:** As a user, I want my system to remain consistent if an install/remove fails.
- **Implementation Steps:**
  1. Track all changes during a transaction.
  2. On failure, revert all changes.
- **Dependencies:** Transaction log, file manager.
- **Test/Validation:** Simulate failure, verify rollback.

### 2.2 Hooks and Triggers
- **Description:** Run scripts before/after package operations.
- **User Story:** As a user, I want to automate actions on install/remove/upgrade.
- **Implementation Steps:**
  1. Detect and execute hooks at appropriate stages.
  2. Pass context (package, operation) to hooks.
- **Dependencies:** Hook manager, event system.
- **Test/Validation:** Custom hooks, error handling.

### 2.3 Repository Management
- **Description:** Add, remove, enable, or disable repositories.
- **User Story:** As a user, I want to manage my package sources.
- **Implementation Steps:**
  1. Parse repo management commands.
  2. Update repo config files.
  3. Sync/refresh as needed.
- **Dependencies:** Config manager, repo sync.
- **Test/Validation:** Add/remove/enable/disable repo, refresh.

### 2.4 Package Groups/Environments/Modules
- **Description:** Install or query groups, environments, or module streams.
- **User Story:** As a user, I want to install or list groups of related packages.
- **Implementation Steps:**
  1. Parse group/module commands.
  2. Query group/module metadata.
  3. Install all members or show info.
- **Dependencies:** Group/module database.
- **Test/Validation:** Install group, list members, handle missing packages.

### 2.5 Advisory/Errata Management
- **Description:** Show and apply security advisories or errata.
- **User Story:** As a user, I want to see and apply security updates.
- **Implementation Steps:**
  1. Sync advisory data from repos.
  2. List advisories, filter by severity/type.
  3. Apply relevant updates.
- **Dependencies:** Advisory database, update engine.
- **Test/Validation:** List/apply advisories, verify update.

---

## 3. Unique Features (Nix, DNF, Pacman)

### 3.1 Declarative System Config (Nix)
- **Description:** Support for declarative system/package configuration.
- **User Story:** As a user, I want to define my system state in a config file and apply it.
- **Implementation Steps:**
  1. Parse config file.
  2. Compute required changes.
  3. Apply changes atomically.
- **Dependencies:** Config parser, transaction engine.
- **Test/Validation:** Apply config, idempotency, rollback.

### 3.2 Rollback/Generations (Nix)
- **Description:** Roll back to previous system states (generations).
- **User Story:** As a user, I want to revert my system to a previous state.
- **Implementation Steps:**
  1. Track system generations.
  2. Allow user to list and switch generations.
- **Dependencies:** State manager, boot integration.
- **Test/Validation:** List/switch generations, verify state.

### 3.3 Module Streams (DNF)
- **Description:** Enable/disable module streams for package sets.
- **User Story:** As a user, I want to select versions/streams of modular packages.
- **Implementation Steps:**
  1. Parse module commands.
  2. Query/enable/disable streams.
- **Dependencies:** Module database.
- **Test/Validation:** Enable/disable/list streams.

### 3.4 File Ownership/Query (Pacman)
- **Description:** Query which package owns a file.
- **User Story:** As a user, I want to find the package that installed a file.
- **Implementation Steps:**
  1. Parse file path from CLI.
  2. Search local database for file ownership.
- **Dependencies:** File index.
- **Test/Validation:** Query file, handle missing files.

---

## 4. General CLI/UX Features

### 4.1 Help/Usage
- **Description:** Show help and usage for all commands and options.
- **User Story:** As a user, I want to see usage info for any command.
- **Implementation Steps:**
  1. Implement help/usage output for all commands.
  2. Provide examples and option explanations.
- **Dependencies:** CLI parser, formatter.
- **Test/Validation:** Help for all commands, correct formatting.

### 4.2 Verbosity/Quiet Modes
- **Description:** Control output verbosity.
- **User Story:** As a user, I want to see more or less output as needed.
- **Implementation Steps:**
  1. Implement verbosity flags.
  2. Adjust output accordingly.
- **Dependencies:** Logger, CLI parser.
- **Test/Validation:** Quiet/verbose output, error handling.

---

## 5. Testing & Validation
- **Unit tests** for all core logic.
- **Integration tests** for end-to-end workflows.
- **User acceptance tests** for CLI/UX.

---

*This roadmap will be updated as features are implemented and refined.*
