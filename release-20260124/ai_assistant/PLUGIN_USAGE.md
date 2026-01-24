# PacNixum AI Assistant Plugin System - Usage & Development

## Overview
The plugin system allows you to extend the AI assistant with new commands, skills, and workflows. Plugins are discovered in the `ai_assistant/plugins/` directory and can be written in ScrapeC, Python, or as Docker containers.

## How Plugins Work
- Each plugin has a manifest (`.json`) describing its entry point, permissions, and metadata.
- The loader scans for plugins and can execute their main entry point.
- Plugins can register new commands, respond to queries, or automate tasks.

## Example Plugin
- `plugins/hello_plugin.scrapec`: Prints a hello message when loaded.
- `plugins/hello_plugin.json`: Manifest for the plugin.

## Adding a Plugin
1. Create a `.scrapec` or `.py` file in `ai_assistant/plugins/`.
2. Add a manifest `.json` file with the same base name.
3. The loader will discover and (in future) execute your plugin.

## Manifest Example
```
{
  "name": "hello-plugin",
  "version": "1.0.0",
  "entry": "hello_plugin.scrapec",
  "permissions": ["query", "log"],
  "author": "ArttulOS Team"
}
```

## Roadmap
- [x] Plugin discovery and manifest parsing
- [ ] Plugin execution and command registration
- [ ] Security sandboxing and permission enforcement
- [ ] Plugin management via GUI/CLI

## Contributing Plugins
- Follow the manifest format
- Keep plugins modular and secure
- Document your plugin’s commands and features

---
For more, see PLUGIN_SYSTEM.md and plugin_loader.scrapec.
