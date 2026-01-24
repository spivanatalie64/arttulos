#!/bin/bash
# Install PacNixum package manager into the target system
set -e

echo "Installing PacNixum..."
# Example: copy PacNixum files (update with real paths as needed)
cp -r ../../pacnixum /mnt/sysimage/opt/pacnixum
ln -sf /opt/pacnixum/cli.scrapec /usr/local/bin/pacnixum
