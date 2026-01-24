#!/bin/bash
# ArttulOS Full Build System Script
set -e

# Variables
RELEASE="2026.01"
WORKDIR="$PWD/build"
ISO_LABEL="ARTTULOS"
OUTPUT="$PWD/arttulos-${RELEASE}.iso"
KICKSTART="$PWD/../configs/arttulos-ks.cfg"

# Step 1: Prepare build environment (Docker)
echo "Building Docker image for ISO build..."
docker build -t arttulos-iso-builder "$PWD" || { echo "Docker build failed."; exit 1; }

# Step 2: Run ISO build in container
echo "Running ISO build in Docker container with package manager integration..."
docker run --rm -v "$PWD:/home/builder/output" arttulos-iso-builder bash -c "\
	echo 'Installing Pacman packages...' && \
	sudo pacman -Sy --noconfirm vim git cinnamon-desktop && \
	echo 'Installing RPM packages...' && \
	sudo rpm -i --test /home/builder/configs/rpm/*.rpm || true && \
	echo 'Installing Nix packages...' && \
	nix-env -iA nixpkgs.cinnamon nixpkgs.git nixpkgs.vim && \
	./build_iso.sh\
" || { echo "ISO build failed."; exit 1; }

# Step 3: Copy output ISO
echo "Copying ISO to output directory..."
find "$PWD" -name '*.iso' -exec mv {} "$OUTPUT" \;
echo "ISO created at $OUTPUT"

# Step 4: Run build-time tests for stability, security, and performance
echo "Running build-time test suite..."
bash "$PWD/test_system.sh" || { echo "Build-time tests failed."; exit 1; }

# Step 5: Post-build steps (optional)
# e.g., sign ISO, generate checksums, publish artifacts

exit 0
