#!/bin/bash
# Install AI Assistant into the target system
set -e

echo "Installing AI Assistant..."
# Example: copy AI Assistant files (update with real paths as needed)
cp -r ../../ai_assistant /mnt/sysimage/opt/ai_assistant
ln -sf /opt/ai_assistant/main.scrapec /usr/local/bin/ai-assistant
