#!/bin/bash
# Install ScrapeC language toolchain into the target system
set -e

echo "Installing ScrapeC..."
# Example: copy ScrapeC files (update with real paths as needed)
cp -r ../../scrapec /mnt/sysimage/opt/scrapec
ln -sf /opt/scrapec/src/main.rs /usr/local/bin/scrapec
