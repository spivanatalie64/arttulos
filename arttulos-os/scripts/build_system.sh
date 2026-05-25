#!/bin/bash
# ArttulOS Full Build System Script (Platform Agnostic, No VM)
set -e

# Step 0: Discover packages to build
PACKAGES_DIR="$PWD/packages"
OUTPUT_DIR="$PWD/built_packages"
mkdir -p "$OUTPUT_DIR" "$PACKAGES_DIR"
echo "Discovered packages:"
ls "$PACKAGES_DIR"

# Step 1: Build each package (prefer Docker, fallback to host)
shopt -s nullglob
pkg_list=("$PACKAGES_DIR"/*)
shopt -u nullglob
if [ ${#pkg_list[@]} -eq 0 ]; then
	echo "No packages found in $PACKAGES_DIR, skipping package build step."
else
for pkg in "${pkg_list[@]}"; do
	[[ "$(basename "$pkg")" == ".gitkeep" ]] && continue
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
fi

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
	echo "Dockerfile not found in expected locations; skipping Docker image build."
	DOCKERFILE_PATH=""
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
shopt -s nullglob
built_list=("$OUTPUT_DIR"/*)
shopt -u nullglob
for pkg in "${built_list[@]}"; do
  pkg_name=$(basename "$pkg" | cut -d. -f1)
  arch_pkg="$OUTPUT_DIR/$pkg_name.art"
  rpm_pkg="$RPM_OUTPUT_DIR/$pkg_name.rpm"
  nix_pkg="$NIX_OUTPUT_DIR/$pkg_name.nix"
  arch_stable=$(bash test_package.sh "$arch_pkg" 2>/dev/null || echo 0)
  rpm_stable=$(bash test_package.sh "$rpm_pkg" 2>/dev/null || echo 0)
  nix_stable=$(bash test_package.sh "$nix_pkg" 2>/dev/null || echo 0)
  if [ "$arch_stable" -ge "$rpm_stable" ] && [ "$arch_stable" -ge "$nix_stable" ]; then
    [ -f "$arch_pkg" ] && cp "$arch_pkg" "$ARTPKGS_DIR/$pkg_name.pkg" && echo "$pkg_name: selected Arch package" >> "$PWD/package_selection.log"
  elif [ "$rpm_stable" -ge "$nix_stable" ]; then
    [ -f "$rpm_pkg" ] && cp "$rpm_pkg" "$ARTPKGS_DIR/$pkg_name.pkg" && echo "$pkg_name: selected RPM package" >> "$PWD/package_selection.log"
  else
    [ -f "$nix_pkg" ] && cp "$nix_pkg" "$ARTPKGS_DIR/$pkg_name.pkg" && echo "$pkg_name: selected Nix package" >> "$PWD/package_selection.log"
  fi
done

# Step 6: Run ISO build in final container, mounting built packages and artpkgs
if command -v docker >/dev/null 2>&1; then
  if docker image inspect arttulos-os-buildenv >/dev/null 2>&1; then
    docker run --rm -v "$OUTPUT_DIR:/built_packages" -v "$ARTPKGS_DIR:/home/builder/../artpkgs" arttulos-os-buildenv bash -c "./build_iso.sh /built_packages" || echo "ISO build failed; skipping."
  else
    echo "Docker image arttulos-os-buildenv not found; skipping ISO build."
  fi
else
  echo "Docker not found; skipping ISO build."
fi

# Step 7: Copy output ISO
OUTPUT="$PWD/output_iso"
mkdir -p "$OUTPUT"
echo "Copying ISO to output directory $OUTPUT..."
find "$PWD" -name '*.iso' -exec mv {} "$OUTPUT" \; 2>/dev/null || true
if ls "$OUTPUT"/*.iso >/dev/null 2>&1; then
  echo "ISO(s) exported to $OUTPUT:"
  ls -lh "$OUTPUT"/*.iso
else
  echo "No ISO produced."
fi

# Step 8: Run build-time tests for stability, security, and performance
echo "Running build-time test suite..."
bash "$PWD/test_system.sh" || echo "Build-time tests failed or not available."

# Step 9: Run auto_git.sh for automated git workflow
if [ -f "$PWD/auto_git.sh" ]; then
  bash "$PWD/auto_git.sh" "build-$(date +%Y%m%d%H%M%S)"
fi

exit 0
