#!/bin/bash
# Build ArttulOS ISO using Docker container
set -e

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

cd "$SCRIPT_DIR"
docker build -t arttulos-iso-builder .
docker run --rm -v "$PROJECT_ROOT/arttulos-os:/home/builder/output" arttulos-iso-builder
