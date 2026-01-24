#!/bin/bash
# ArttulOS ISO build script
# Usage: sudo ./build_iso.sh
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

# Clean build dir
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

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
