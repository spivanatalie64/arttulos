#!/bin/bash
# Install and enable ArttulOS custom login manager systemd service
set -e

SERVICE_SRC="$(dirname "$0")/login_manager.service"
SERVICE_DEST="/etc/systemd/system/login_manager.service"
MANAGER_SRC="$(dirname "$0")"
MANAGER_DEST="/home/builder/login_manager"

sudo mkdir -p "$MANAGER_DEST"
sudo cp -r "$MANAGER_SRC"/* "$MANAGER_DEST"/
sudo cp "$SERVICE_SRC" "$SERVICE_DEST"
sudo systemctl disable display-manager.service || true
sudo systemctl enable login_manager.service
sudo systemctl start login_manager.service

echo "Custom login manager installed and started."
