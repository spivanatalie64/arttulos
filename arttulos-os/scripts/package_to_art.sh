#!/bin/bash
# Convert a package (and its dependencies) from pacman, rpm, or nix into an .art package
# Usage: ./package_to_art.sh <package> <source: pacman|rpm|nix> <output-dir>
set -e

PKG_NAME="$1"
PKG_SRC="$2"
OUTDIR="$3"

if [[ -z "$PKG_NAME" || -z "$PKG_SRC" || -z "$OUTDIR" ]]; then
  echo "Usage: $0 <package> <source: pacman|rpm|nix> <output-dir>"
  exit 1
fi

STAGE="/tmp/art-stage-$PKG_NAME-$$"
mkdir -p "$STAGE"

case "$PKG_SRC" in
  pacman)
    # Download package and dependencies (without installing)
    sudo pacman -Sy --noconfirm
    sudo pacman -Sw --noconfirm --cachedir "$STAGE" "$PKG_NAME"
    # Extract all packages
    for f in "$STAGE"/*.pkg.tar.*; do
      tar -xf "$f" -C "$STAGE"
    done
    ;;
  rpm)
    # Download RPM and dependencies
    mkdir -p "$STAGE/rpms"
    sudo dnf download --resolve --destdir="$STAGE/rpms" "$PKG_NAME"
    for f in "$STAGE/rpms"/*.rpm; do
      rpm2cpio "$f" | (cd "$STAGE" && cpio -idmv)
    done
    ;;
  nix)
    # Build and copy closure
    nix-env -iA nixpkgs."$PKG_NAME"
    OUT_PATH=$(nix-build '<nixpkgs>' -A "$PKG_NAME")
    cp -a "$OUT_PATH" "$STAGE/"
    ;;
  *)
    echo "Unknown source: $PKG_SRC"; exit 2
    ;;
esac

# Create manifest
find "$STAGE" -type f > "$STAGE/manifest.txt"

# Create .art package (tarball)
ART_PKG="$OUTDIR/$PKG_NAME.art"
tar -czf "$ART_PKG" -C "$STAGE" .

echo ".art package created: $ART_PKG"
rm -rf "$STAGE"
