# Onboarding Guide: ArttulOS Project

Welcome to the ArttulOS project! This guide will help you get started with development, testing, and contributing to PacNixum, ScrapeC, and the AI Assistant.

## Prerequisites
- Linux (RHEL-compatible recommended)
- Docker (for AI Assistant)
- Rust (for ScrapeC tests)
- Python 3 (for some scripts)
- Git

## Quick Start
1. Clone the repository:
   ```sh
   git clone https://github.com/spivanatalie64/arttulos.git
   cd arttulos
   ```
2. Install dependencies (see each subproject's README for details).
3. Run tests:
   - ScrapeC: `cd scrapec && cargo test`
   - PacNixum: `cd pacnixum && ./cli.scrapec --test`
   - AI Assistant: `cd ai_assistant && ./main.scrapec --test`

## Directory Structure
- `scrapec/` — ScrapeC language and tools
- `pacnixum/` — PacNixum package manager
- `ai_assistant/` — Modular AI assistant

## Contributing
See `CONTRIBUTING.md` for guidelines.

## More Info
- Each subproject has its own README and usage examples.
- For plugin development, see `ai_assistant/PLUGIN_SYSTEM.md`.

# Security, Resource Limits, and Performance

ArttulOS, PacNixum, and the AI Assistant are designed with security and efficiency in mind. Here’s what’s implemented and what’s planned:

- **AI Assistant**
  - Prompts users to enable rootless mode, memory/CPU limits, network isolation, and energy efficiency when launching AI containers.
  - Uses Docker arguments (`--memory=2g`, `--cpus=2`, `--userns=host`) to enforce some limits.
  - Security and sandboxing for plugins are planned but not yet implemented.
  - Error handling and logging are present throughout the interface and test cases.
  - Performance is a design goal, but no explicit benchmarks or profiling hooks are present yet.

- **PacNixum**
  - Security, error handling, and logging are planned (see `PLAN.md` and `CHECKLIST.md`), but backend logic is still a skeleton.
  - Performance and safety are core design goals (see `WHY_SCRAPEC.md`).

**Recommendations for Contributors:**
- Implement plugin sandboxing and permission enforcement for the AI Assistant.
- Ensure all security/resource options are enforced, not just prompted.
- Integrate logging and error reporting in PacNixum backend logic.
- Add performance benchmarks and profiling hooks for both systems.
- Document all security and performance features in user and developer docs.

For more details, see the relevant README, PLAN, and CHECKLIST files in each subproject.

Happy hacking!
