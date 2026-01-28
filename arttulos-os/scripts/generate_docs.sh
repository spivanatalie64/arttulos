#!/bin/bash
# Generate documentation and release version file
set -e

DOCS_DIR="$PWD/../docs"
RELEASE_FILE="$PWD/../RELEASE_VERSION.txt"

mkdir -p "$DOCS_DIR"
echo "ArttulOS Release Documentation" > "$DOCS_DIR/README.md"
echo "Release Version: 2026.01" > "$RELEASE_FILE"
echo "Documentation and release version generated."
