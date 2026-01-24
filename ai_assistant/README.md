# AI Assistant

The ArttulOS AI Assistant is a modular, containerized, and extensible local AI system. It supports multiple backends, persistent storage, advanced query routing, plugin support, and both GUI/TUI frontends.

## Features
- Runs AI models as Docker containers (with compatibility layer)
- Multi-backend support (LLM, code, sysinfo, etc.)
- Plugin system (see `plugins/` and `PLUGIN_SYSTEM.md`)
- Persistent storage, logging, and advanced error handling
- Security, resource limits, and sandboxing
- GUI and CLI integration
- Easy onboarding and extensibility

See `USAGE.md`, `EXAMPLES.md`, and `ROADMAP.md` for more details.

# PacNixum Local AI Assistant

This is the modular AI assistant for ArttulOS and PacNixum. It is designed to provide interactive help, advanced troubleshooting, and command guidance for package management and system administration tasks.

## Features
- Interactive Q&A for package management
- Command suggestion and explanation
- Troubleshooting workflows
- Modular backend for future LLM or rules engine integration
- Designed for CLI and GUI integration

## Usage
This module is not yet integrated with PacNixum. To test, run the main script in this folder.

## Roadmap
- [ ] Integrate with PacNixum advanced menu
- [ ] Add LLM/rules engine backend
- [ ] Expand troubleshooting and workflow scripts
- [ ] Add GUI frontend (optional)
