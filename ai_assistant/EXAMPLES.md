# PacNixum AI Assistant - Example Usage

## Launching the GUI Frontend
```
scrapec ai_assistant/gui_frontend.scrapec
```

## Launching from PacNixum CLI
```
scrapec pacnixum/cli.scrapec ai-assist launch
```

## Querying an Assistant Directly
```
scrapec pacnixum/cli.scrapec ai-assist query gpt4 "How do I update all packages?"
```

## Enabling Persistent Storage
- When prompted, enter a directory (e.g., `./ai_logs/gpt4`)
- Logs and data will be saved there

## Enabling Security & Energy Efficiency
- When prompted, choose to enable rootless mode, resource limits, and auto-pause

## Using Multiple Assistants
- Use the interactive menu to launch and query several assistants in parallel

## Streaming Responses
- When prompted, choose to stream output for real-time results

## Troubleshooting
- Follow the step-by-step guidance if you encounter Docker, network, or port issues

---
For more, see USAGE.md and DOCKER_COMPAT.md.
