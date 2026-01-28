#!/bin/bash
# Install all .art packages into a target root (e.g., for OS build)
# Usage: ./install_art_packages.sh <artpkgs-dir> <target-root>
set -e

ARTPKGS_DIR="$1"
TARGET_ROOT="$2"

if [[ -z "$ARTPKGS_DIR" || -z "$TARGET_ROOT" ]]; then
  echo "Usage: $0 <artpkgs-dir> <target-root>"
  exit 1
fi

mkdir -p "$TARGET_ROOT"

for artpkg in "$ARTPKGS_DIR"/*.art; do
  echo "Installing $artpkg into $TARGET_ROOT ..."
  tar -xzf "$artpkg" -C "$TARGET_ROOT"
  # Optionally, handle manifest or post-install hooks here
  if [ -f "$TARGET_ROOT/manifest.txt" ]; then
    rm "$TARGET_ROOT/manifest.txt"
  fi
  echo "Installed: $artpkg"
done

echo "All .art packages installed to $TARGET_ROOT"