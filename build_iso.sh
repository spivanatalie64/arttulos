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

# Install all .art packages into the OS root before building the ISO
ARTPKGS_DIR="$PWD/../artpkgs"
TARGET_ROOT="$WORKDIR/rootfs"
mkdir -p "$TARGET_ROOT"
if compgen -G "$ARTPKGS_DIR/*.art" > /dev/null; then
  bash "$PWD/install_art_packages.sh" "$ARTPKGS_DIR" "$TARGET_ROOT"
else
  echo "No .art packages found in $ARTPKGS_DIR. Aborting."; exit 1
fi


# Ensure a valid mirrorlist is always present before any Pacman command
echo "Ensuring valid Arch mirrorlist in chroot..."
sudo arch-chroot /archroot bash -c '
  MIRRORLIST=/etc/pacman.d/mirrorlist
  MIRRORLIST_BAK=/etc/pacman.d/mirrorlist.pacnew
  # If backup does not exist, make one from the current mirrorlist
  if [ ! -f "$MIRRORLIST_BAK" ] && [ -f "$MIRRORLIST" ]; then
    cp "$MIRRORLIST" "$MIRRORLIST_BAK"
  fi
  # If mirrorlist is missing or empty, restore from backup
  if [ ! -s "$MIRRORLIST" ] && [ -f "$MIRRORLIST_BAK" ]; then
    cp "$MIRRORLIST_BAK" "$MIRRORLIST"
  fi
  # Optionally, try to update with reflector, but do not fail if it does not work
  if command -v reflector >/dev/null 2>&1; then
    reflector --country "United States" --age 12 --protocol https --sort rate --save "$MIRRORLIST" || true
  fi
  echo "Mirrorlist preview (in chroot):"
  head -20 "$MIRRORLIST"
'

# Clean build dir
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"




# Initialize and populate Pacman keyring in chroot (requires --privileged or --cap-add=SYS_ADMIN)
echo "Initializing Pacman keyring in Arch chroot..."
sudo arch-chroot /archroot pacman-key --init
sudo arch-chroot /archroot pacman-key --populate archlinux
sudo arch-chroot /archroot pacman-key --refresh-keys

# Output package sources and stability ratings
bash "$PWD/package_sources.sh"

# Install a combination of packages for stability
echo "Installing Pacman packages (in Arch chroot)..."
sudo arch-chroot /archroot pacman -Sy --noconfirm vim git cinnamon-desktop

echo "Installing RPM packages..."
sudo rpm -i --test /home/builder/configs/rpm/*.rpm || true

echo "Installing Nix packages..."
nix-env -iA nixpkgs.cinnamon nixpkgs.git nixpkgs.vim

# Generate documentation and release version file
bash "$PWD/generate_docs.sh"

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
