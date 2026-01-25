#!/bin/bash
# ArttulOS Full Build System Script
set -e

# Variables (must be set before use)
ARCHROOT_HOST="/tmp/archroot-host"
PACMANCONF_PATH="$ARCHROOT_HOST/etc/pacman.conf"
MIRRORLIST_PATH="$ARCHROOT_HOST/etc/pacman.d/mirrorlist"


# Step 0: Discover packages to build
PACKAGES_DIR="$PWD/packages"
OUTPUT_DIR="$PWD/built_packages"
mkdir -p "$OUTPUT_DIR"
if [ ! -d "$PACKAGES_DIR" ]; then
	echo "Packages directory $PACKAGES_DIR not found!"; exit 1;
fi
echo "Discovered packages:"
ls "$PACKAGES_DIR"

# Step 1: Build each package in its own container
for pkg in "$PACKAGES_DIR"/*; do
	pkg_name=$(basename "$pkg")
	echo "Building package $pkg_name in isolated container..."
	docker run --rm -v "$pkg:/src" -v "$OUTPUT_DIR:/output" arttulos-os-buildenv bash -c '
		set -e
		cd /src
		if [ -f build.sh ]; then
			bash build.sh /output || { echo "Build failed for $pkg_name"; exit 1; }
		else
			echo "No build.sh in $pkg_name, skipping."
		fi
	'
done
echo "All packages built. Artifacts in $OUTPUT_DIR."

# Step 1.5: Prepare build environment (Docker)
echo "Building Docker image for ISO build..."

# Argument parsing for --dockerfile
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

# Determine Dockerfile path and context
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



# Log forced mirrorlist and pacman.conf (host chroot)
echo "--- BEGIN mirrorlist (host chroot) ---"
sudo cat "$MIRRORLIST_PATH"
echo "--- END mirrorlist (host chroot) ---"
echo "--- BEGIN pacman.conf (host chroot) ---"
sudo cat "$PACMANCONF_PATH"
echo "--- END pacman.conf (host chroot) ---"

# Log contents inside chroot before Pacman runs
echo "--- BEGIN mirrorlist (inside chroot) ---"
sudo arch-chroot "$ARCHROOT_HOST" cat /etc/pacman.d/mirrorlist || echo "Mirrorlist missing in chroot!"
echo "--- END mirrorlist (inside chroot) ---"
echo "--- BEGIN pacman.conf (inside chroot) ---"
sudo arch-chroot "$ARCHROOT_HOST" cat /etc/pacman.conf || echo "pacman.conf missing in chroot!"
echo "--- END pacman.conf (inside chroot) ---"
echo "--- BEGIN pacman.conf (patched) ---"
sudo cat "$PACMANCONF_PATH"
echo "--- END pacman.conf (patched) ---"
# Ensure valid Arch mirrorlist in chroot
MIRRORLIST_PATH="$ARCHROOT_HOST/etc/pacman.d/mirrorlist"
if [ ! -f "$MIRRORLIST_PATH" ] || [ ! -s "$MIRRORLIST_PATH" ]; then
	echo "Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch" | sudo tee "$MIRRORLIST_PATH" > /dev/null
fi
# Cleanup any extracted chroot from project directory to avoid Docker context issues
if [ -d "$PWD/root.x86_64" ]; then
	echo "Removing stale $PWD/root.x86_64 from project directory..."
	sudo rm -rf "$PWD/root.x86_64"
fi
if [ -d "$PWD/archroot-host" ]; then
	echo "Removing stale $PWD/archroot-host from project directory..."
	sudo rm -rf "$PWD/archroot-host"
fi
docker build -t arttulos-os-buildenv -f "$DOCKERFILE_PATH" "$DOCKER_CONTEXT" || { echo "Docker build failed."; exit 1; }

# Step 2: Run ISO build in container
echo "Preparing host chroot for Arch..."
ARCHROOT_HOST="/tmp/archroot-host"
if [ -d "$ARCHROOT_HOST" ]; then
	sudo rm -rf "$ARCHROOT_HOST"/*
else
	sudo mkdir -p "$ARCHROOT_HOST"
fi
if [ -z "$(ls -A "$ARCHROOT_HOST" 2>/dev/null)" ]; then
	echo "Extracting Arch bootstrap into host chroot..."
	curl -O https://geo.mirror.pkgbuild.com/iso/2026.01.01/archlinux-bootstrap-x86_64.tar.zst
	sudo tar -I unzstd -xf archlinux-bootstrap-x86_64.tar.zst -C "$ARCHROOT_HOST/.."
	sudo mv "$ARCHROOT_HOST/../root.x86_64"/* "$ARCHROOT_HOST/"
	sudo rmdir "$ARCHROOT_HOST/../root.x86_64"
	rm archlinux-bootstrap-x86_64.tar.zst
fi
for d in proc sys dev; do
	if [ ! -d "$ARCHROOT_HOST/$d" ]; then
		sudo mkdir -p "$ARCHROOT_HOST/$d"
	fi
done
echo "Running ISO build in Docker container with package manager integration..."

# Step 2: Run ISO build in final container, mounting built packages
docker run --rm --privileged \
	-v "$PWD:/home/builder/output" \
	-v "$ARCHROOT_HOST:/archroot" \
	-v "$OUTPUT_DIR:/built_packages" \
	arttulos-os-buildenv bash -c "\
	./build_iso.sh /built_packages\
" || { echo "ISO build failed."; exit 1; }


# Robust Pacman keyring initialization and refresh in chroot
echo "Initializing and refreshing Pacman keyring in chroot..."
sudo arch-chroot "$ARCHROOT_HOST" bash -c '
	pacman-key --init && \
	pacman-key --populate archlinux && \
	pacman-key --refresh-keys --keyserver hkps://keyserver.ubuntu.com || \
	pacman-key --refresh-keys --keyserver hkps://keys.openpgp.org || \
	pacman-key --refresh-keys --keyserver hkp://pool.sks-keyservers.net:11371 || true
'
# Enable auto-key-retrieve for pacman in chroot
sudo arch-chroot "$ARCHROOT_HOST" bash -c '
	grep -q "^\s*KeyserverOptions" /etc/pacman.d/gnupg/gpg.conf || echo "keyserver-options auto-key-retrieve" >> /etc/pacman.d/gnupg/gpg.conf
'
echo "Pacman keyring status in chroot:"
sudo arch-chroot "$ARCHROOT_HOST" pacman-key --list-keys | head -20


# Step 3: Copy output ISO
OUTPUT="$PWD/output_iso"
mkdir -p "$OUTPUT"
echo "Copying ISO to output directory $OUTPUT..."
find "$PWD" -name '*.iso' -exec mv {} "$OUTPUT" \;
echo "ISO(s) exported to $OUTPUT:"
ls -lh "$OUTPUT"/*.iso

# Step 4: Run build-time tests for stability, security, and performance
echo "Running build-time test suite..."
bash "$PWD/test_system.sh" || { echo "Build-time tests failed."; exit 1; }

# Step 5: Post-build steps (optional)
# e.g., sign ISO, generate checksums, publish artifacts

exit 0
