#!/bin/bash
# Install and enable ArttulOS boot message systemd service
set -e

SERVICE_SRC="$(dirname "$0")/boot-message.service"
SERVICE_DEST="/etc/systemd/system/boot-message.service"

sudo cp "$SERVICE_SRC" "$SERVICE_DEST"
sudo systemctl enable boot-message.service
sudo systemctl start boot-message.service

echo "Boot message service installed and started."
