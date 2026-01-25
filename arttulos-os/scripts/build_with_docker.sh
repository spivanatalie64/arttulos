#!/bin/bash
# Build ArttulOS ISO using Docker container
set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

cd "$SCRIPT_DIR"
docker build -t arttulos-iso-builder .
echo "\n[INFO] For chroot operations, run the container with --privileged or --cap-add=SYS_ADMIN.\n"
mkdir -p "$PROJECT_ROOT/arttulos-os/archroot-host"
docker run --rm --privileged \
	-v "$PROJECT_ROOT/arttulos-os:/home/builder/output" \
	-v "$PROJECT_ROOT/arttulos-os/archroot-host:/archroot" \
	arttulos-iso-builder
# Ensure host /archroot-host is created and empty
ARCHROOT_HOST="$PROJECT_ROOT/arttulos-os/archroot-host"
if [ -d "$ARCHROOT_HOST" ]; then
	rm -rf "$ARCHROOT_HOST"/*
else
	mkdir -p "$ARCHROOT_HOST"
fi
docker run --rm --privileged \
	-v "$PROJECT_ROOT/arttulos-os:/home/builder/output" \
	-v "$ARCHROOT_HOST:/archroot" \
	arttulos-iso-builder
