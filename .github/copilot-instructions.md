# Copilot Instructions for ArttulOS & PacNixum AI Assistant

## Project Overview
- **ArttulOS** is a modular Linux distribution with custom desktop, packaging, and system integration layers. See `README.md` for structure.
- **PacNixum AI Assistant** is a local, containerized, and extensible AI system (see `ai_assistant/`). It supports plugins, multiple backends, persistent storage, and both GUI/TUI frontends.
- **ScrapeC** is a custom systems language (see `scrapec/`) used for core tools and the AI assistant.

## Key Architectural Patterns
- **AI Assistant**: Modular, plugin-based, and containerized. Plugins live in `ai_assistant/plugins/` and are described in `PLUGIN_SYSTEM.md`.
- **Backends**: AI models run as Docker containers (see `DOCKER_COMPAT.md`). All queries and commands are routed via container interfaces.
- **Extensibility**: New skills/workflows are added as plugins (ScrapeC, Python, or Docker). See plugin manifest example in `PLUGIN_SYSTEM.md`.
- **Security**: All assistants run in isolated containers with enforced permissions and resource limits.
- **Data Flow**: User queries → CLI/GUI → AI assistant → containerized backend → response (optionally streamed).

## Developer Workflows
- **Build/Run AI Assistant**:
  - GUI: `scrapec ai_assistant/gui_frontend.scrapec`
  - CLI: `scrapec pacnixum/cli.scrapec ai-assist launch`
- **Query Example**: `scrapec pacnixum/cli.scrapec ai-assist query gpt4 "How do I rollback a package?"`
- **Plugin Development**: Add to `ai_assistant/plugins/`, declare manifest, follow API in `PLUGIN_SYSTEM.md`.
- **Persistent Storage**: Specify a host directory when prompted; data mounts to `/data` in the container.
- **Security/Energy**: Enable rootless Docker, resource limits, and auto-pause when prompted.

## Project-Specific Conventions
- **Language**: Use ScrapeC for core logic; Python or Docker for plugins.
- **Plugin Manifest**: JSON with `name`, `version`, `entry`, `permissions`, `author`.
- **Testing**: Automated tests live in `tests/` and `ai_assistant/test_*.scrapec`.
- **Documentation**: See `ai_assistant/USAGE.md`, `EXAMPLES.md`, and `ROADMAP.md` for usage and roadmap.

## Integration Points
- **Docker**: All AI models run as containers. See `DOCKER_COMPAT.md` for API and security details.
- **CLI/GUI**: Both interfaces route to the same backend logic.
- **Plugin API**: Stable API for plugins to register commands, hooks, and event handlers.

## Examples
- Add a plugin: Place in `ai_assistant/plugins/`, add manifest, and follow `PLUGIN_SYSTEM.md`.
- Launch assistant: `scrapec ai_assistant/gui_frontend.scrapec` or via CLI as above.
- Query: `scrapec pacnixum/cli.scrapec ai-assist query gpt4 "..."`

## References
- `ai_assistant/PLUGIN_SYSTEM.md`, `USAGE.md`, `EXAMPLES.md`, `DOCKER_COMPAT.md`, `ROADMAP.md`
- Top-level `README.md` for project structure
- `scrapec/README.md` for language details

---
For unclear or missing conventions, consult the referenced docs or ask a maintainer.
