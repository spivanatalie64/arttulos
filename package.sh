#!/bin/bash
# ArttulOS/PacNixum/AI Assistant packaging script
set -e

RELEASE_DIR="release-$(date +%Y%m%d)"
mkdir -p "$RELEASE_DIR"

# Copy main project files
cp -r README.md LICENSE ONBOARDING.md USAGE_EXAMPLES.md RELEASE_NOTES.md $RELEASE_DIR/
cp -r CONTRIBUTING.md CODE_OF_CONDUCT.md ROADMAP.md $RELEASE_DIR/

# Copy subprojects
cp -r pacnixum $RELEASE_DIR/
cp -r ai_assistant $RELEASE_DIR/
cp -r scrapec $RELEASE_DIR/

# Remove test logs, cache, and temp files if any
find "$RELEASE_DIR" -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
find "$RELEASE_DIR" -type f -name '*.log' -delete 2>/dev/null || true

# Create archive
zip -r "$RELEASE_DIR.zip" "$RELEASE_DIR"
echo "Release package created: $RELEASE_DIR.zip"
