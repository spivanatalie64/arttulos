#!/bin/bash
# ArttulOS ISO build script (platform agnostic, no chroot)
# Usage: ./build_iso.sh
set -e

# Variables (edit as needed)
OS_NAME="ArttulOS"
RELEASE="2026.01"
WORKDIR="$PWD/build"
KICKSTART="../configs/arttulos-ks.cfg"
ISO_LABEL="ARTTULOS"
OUTPUT="../arttulos-${RELEASE}.iso"

# Ensure dependencies
command -v livecd-creator >/dev/null 2>&1 || { echo >&2 "livecd-creator is required. Aborting."; exit 1; }

# Install all .art packages into the OS root before building the ISO
ARTPKGS_DIR="$PWD/../artpkgs"
TARGET_ROOT="$WORKDIR/rootfs"
mkdir -p "$TARGET_ROOT"
if compgen -G "$ARTPKGS_DIR/*.art" > /dev/null; then
  bash "$PWD/install_art_packages.sh" "$ARTPKGS_DIR" "$TARGET_ROOT"
else
  echo "No .art packages found in $ARTPKGS_DIR. Aborting."; exit 1
fi

# Clean build dir
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

# Output package sources and stability ratings
if [ -f "$PWD/package_sources.sh" ]; then
  bash "$PWD/package_sources.sh"
fi

# Install a combination of packages for stability (host or Docker, not chroot)
echo "Installing Pacman packages (host or Docker, not chroot)..."
if command -v pacman >/dev/null 2>&1; then
  sudo pacman -Sy --noconfirm vim git cinnamon-desktop || true
fi
if command -v rpm >/dev/null 2>&1; then
  echo "Installing RPM packages..."
  sudo rpm -i --test /home/builder/configs/rpm/*.rpm || true
fi
if command -v nix-env >/dev/null 2>&1; then
  echo "Installing Nix packages..."
  nix-env -iA nixpkgs.cinnamon nixpkgs.git nixpkgs.vim || true
fi

# Generate documentation and release version file
if [ -f "$PWD/generate_docs.sh" ]; then
  bash "$PWD/generate_docs.sh"
fi

# Build ISO
sudo livecd-creator \
  --config="$KICKSTART" \
  --fslabel="$ISO_LABEL" \
  --cache="$WORKDIR/cache" \
  --tmpdir="$WORKDIR/tmp" \
  --releasever=8 \
  --title="$OS_NAME $RELEASE" \
  --verbose \
  --resultdir="$WORKDIR"

# Move ISO to output
find "$WORKDIR" -name '*.iso' -exec mv {} "$OUTPUT" \;
echo "ISO created at $OUTPUT"
