# PacNixum AI Assistant System - Documentation & Usage

## Overview
The PacNixum AI Assistant system provides advanced, modular, and secure AI-powered help for package management and system tasks. It supports Docker-based assistants, energy efficiency, persistent storage, multi-backend, streaming, and GUI/TUI frontends.

## Features
- Launch and manage AI assistants as Docker containers
- Energy-efficient and secure operation (resource limits, sandboxing)
- Persistent storage and logging for all assistants
- Multiple AI backends and parallel assistants
- Advanced query routing (HTTP, gRPC, WebSocket, CLI)
- Streaming responses for real-time output
- GUI/TUI and CLI integration
- PacNixum CLI integration for seamless workflow

## Quick Start
1. Ensure Docker is installed (the system will attempt to install rootless Docker if not found)
2. Run the GUI frontend: `scrapec ai_assistant/gui_frontend.scrapec`
3. Or use the PacNixum CLI: `scrapec pacnixum/cli.scrapec ai-assist launch`
4. Follow prompts to select, launch, and interact with AI assistants

## Example: Querying an Assistant
```
scrapec pacnixum/cli.scrapec ai-assist query gpt4 "How do I rollback a package?"
```

## Persistent Storage
- When prompted, specify a host directory for logs/data (default: ./ai_logs/<assistant>)
- Data is mounted to /data in the container

## Security & Energy Efficiency
- Enable rootless mode, memory/CPU limits, and network isolation when prompted
- Optionally enable auto-pause for energy savings

## Advanced Query Routing
- Choose HTTP, gRPC, WebSocket, or CLI for queries
- Enable streaming for real-time output

## Troubleshooting
- The system provides step-by-step help for Docker/network issues, port conflicts, and more

## Extending
- Add new AI backends by specifying Docker images
- Use the plugin system (coming soon) for custom skills

## More Info
- See ROADMAP.md and DOCKER_COMPAT.md for technical details
- For help, run with `--help` or use the AI assistant itself!
