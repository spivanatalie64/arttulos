#!/bin/bash
# Output package sources and stability ratings

# Define packages and their sources
PACKAGES=("vim" "git" "cinnamon-desktop")
SOURCES=("pacman" "rpm" "nix")

# Example stability ratings (1-5, 5=most stable)
declare -A RATINGS
RATINGS[pacman]=4
RATINGS[rpm]=5
RATINGS[nix]=3

for pkg in "${PACKAGES[@]}"; do
  echo "Package: $pkg"
  for src in "${SOURCES[@]}"; do
    echo "  Source: $src (Stability: ${RATINGS[$src]}/5)"
  done
  # Select most stable source
  best=$(for src in "${SOURCES[@]}"; do echo "$src ${RATINGS[$src]}"; done | sort -k2 -nr | head -1 | cut -d' ' -f1)
  echo "  Recommended: $best"
  echo
  # Optionally install from best source
  # ...
done
