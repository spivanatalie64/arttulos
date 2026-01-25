#!/bin/bash
# ArttulOS Full Build System Script (Platform Agnostic, No VM)
set -e

# Step 0: Discover packages to build
PACKAGES_DIR="$PWD/packages"
OUTPUT_DIR="$PWD/built_packages"
mkdir -p "$OUTPUT_DIR"
if [ ! -d "$PACKAGES_DIR" ]; then
	echo "Packages directory $PACKAGES_DIR not found!"; exit 1;
fi
echo "Discovered packages:"
ls "$PACKAGES_DIR"

# Step 1: Build each package (prefer Docker, fallback to host)
for pkg in "$PACKAGES_DIR"/*; do
	pkg_name=$(basename "$pkg")
	echo "Building package $pkg_name..."
	if command -v docker >/dev/null 2>&1; then
		echo "Using Docker for $pkg_name..."
		docker run --rm -v "$pkg:/src" -v "$OUTPUT_DIR:/output" arttulos-os-buildenv bash -c '
			set -e
			cd /src
			if [ -f build.sh ]; then
				bash build.sh /output || { echo "Build failed for $pkg_name"; exit 1; }
			else
				echo "No build.sh in $pkg_name, skipping."
			fi
		'
	else
		echo "Docker not found, building $pkg_name on host..."
		cd "$pkg"
		if [ -f build.sh ]; then
			bash build.sh "$OUTPUT_DIR" || { echo "Build failed for $pkg_name"; exit 1; }
		else
			echo "No build.sh in $pkg_name, skipping."
		fi
		cd -
	fi
done
echo "All packages built. Artifacts in $OUTPUT_DIR."

# Step 1.6: Prepare artpkgs directory for ISO build
ARTPKGS_DIR="$PWD/artpkgs"
mkdir -p "$ARTPKGS_DIR"
find "$OUTPUT_DIR" -name '*.art' -exec cp {} "$ARTPKGS_DIR" \;
echo "Copied built .art packages to $ARTPKGS_DIR."

# Step 1.7: Prepare build environment (Docker)
DOCKERFILE_ARG=""
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	echo "Usage: $0 [--dockerfile /path/to/Dockerfile]"
	exit 0
fi
while [[ $# -gt 0 ]]; do
	case $1 in
		--dockerfile)
			DOCKERFILE_ARG="$2"; shift 2;;
		*) shift;;
	esac
done
if [ -n "$DOCKERFILE_ARG" ]; then
	DOCKERFILE_PATH="$DOCKERFILE_ARG"
	DOCKER_CONTEXT="$(dirname "$DOCKERFILE_ARG")"
elif [ -f "$PWD/Dockerfile" ]; then
	DOCKERFILE_PATH="$PWD/Dockerfile"
	DOCKER_CONTEXT="$PWD"
elif [ -f "$PWD/scripts/Dockerfile" ]; then
	DOCKERFILE_PATH="$PWD/scripts/Dockerfile"
	DOCKER_CONTEXT="$PWD/scripts"
else
	echo "Dockerfile not found in expected locations."; exit 1;
fi

# Step 2: (No VM/archinstall step)
# Step 3: Use built packages for ISO build
# (No need to build packages in Docker, use ./built_packages as source)

# Step 4: Build RPM and Nix packages (if not already built)
RPM_OUTPUT_DIR="$PWD/built_rpm_packages"
NIX_OUTPUT_DIR="$PWD/built_nix_packages"
mkdir -p "$RPM_OUTPUT_DIR" "$NIX_OUTPUT_DIR"
# Example: bash build_rpm_packages.sh "$RPM_OUTPUT_DIR"
# Example: bash build_nix_packages.sh "$NIX_OUTPUT_DIR"

# Step 5: Compare Arch, RPM, and Nix packages for stability
for pkg in "$OUTPUT_DIR"/*; do
  pkg_name=$(basename "$pkg" | cut -d. -f1)
  arch_pkg="$OUTPUT_DIR/$pkg_name.art"
  rpm_pkg="$RPM_OUTPUT_DIR/$pkg_name.rpm"
  nix_pkg="$NIX_OUTPUT_DIR/$pkg_name.nix"
  # Stability check (dummy logic, replace with real tests)
  arch_stable=$(bash test_package.sh "$arch_pkg" || echo 0)
  rpm_stable=$(bash test_package.sh "$rpm_pkg" || echo 0)
  nix_stable=$(bash test_package.sh "$nix_pkg" || echo 0)
  # Choose the most stable
  if [ "$arch_stable" -ge "$rpm_stable" ] && [ "$arch_stable" -ge "$nix_stable" ]; then
    cp "$arch_pkg" "$ARTPKGS_DIR/$pkg_name.pkg"
    echo "$pkg_name: selected Arch package" >> "$PWD/package_selection.log"
  elif [ "$rpm_stable" -ge "$nix_stable" ]; then
    cp "$rpm_pkg" "$ARTPKGS_DIR/$pkg_name.pkg"
    echo "$pkg_name: selected RPM package" >> "$PWD/package_selection.log"
  else
    cp "$nix_pkg" "$ARTPKGS_DIR/$pkg_name.pkg"
    echo "$pkg_name: selected Nix package" >> "$PWD/package_selection.log"
  fi
done

# Step 6: Run ISO build in final container, mounting built packages and artpkgs
if command -v docker >/dev/null 2>&1; then
  docker run --rm -v "$OUTPUT_DIR:/built_packages" -v "$ARTPKGS_DIR:/home/builder/../artpkgs" arttulos-os-buildenv bash -c "./build_iso.sh /built_packages" || { echo "ISO build failed."; exit 1; }
else
  echo "Docker not found, running ISO build on host..."
  bash ./build_iso.sh "$OUTPUT_DIR" || { echo "ISO build failed."; exit 1; }
fi

# Step 7: Copy output ISO
OUTPUT="$PWD/output_iso"
mkdir -p "$OUTPUT"
echo "Copying ISO to output directory $OUTPUT..."
find "$PWD" -name '*.iso' -exec mv {} "$OUTPUT" \;
echo "ISO(s) exported to $OUTPUT:"
ls -lh "$OUTPUT"/*.iso

# Step 8: Run build-time tests for stability, security, and performance
echo "Running build-time test suite..."
bash "$PWD/test_system.sh" || { echo "Build-time tests failed."; exit 1; }

# Step 9: Run auto_git.sh for automated git workflow
if [ -f "$PWD/auto_git.sh" ]; then
  bash "$PWD/auto_git.sh" "build-$(date +%Y%m%d%H%M%S)"
fi

exit 0
