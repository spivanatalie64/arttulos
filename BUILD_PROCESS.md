# Build Process and Scripts

## Main Build Script: `build_system.sh`
- Orchestrates the entire build process.
- Discovers all packages in the `packages/` directory.
- For each package:
  - Runs its build script in a dedicated Docker container.
  - Collects the resulting `.art` artifact into the `artpkgs/` directory.
- After all packages are built, launches the final build container to assemble the ISO using `build_iso.sh`.

## ISO Build Script: `build_iso.sh`
- Runs inside the final build container.
- Installs all `.art` packages into the root filesystem.
- Assembles and exports the final ISO image.

## Supporting Scripts
- `install_art_packages.sh`: Installs `.art` packages into the build root.
- Package build scripts (e.g., `packages/hello/build.sh`): Create valid `.tar.gz` artifacts for each package.

## Directory Structure
- `packages/`: Contains all package sources and build scripts.
- `artpkgs/`: Collects all built package artifacts.
- `configs/`: Configuration files for the build environment.

## Automation
- All scripts are designed to run without manual intervention, handling errors and context setup automatically.
