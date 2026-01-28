# Docker Container Usage

## Per-Package Build Containers
- Each package is built in its own Docker container for isolation and reproducibility.
- The container mounts the package source and outputs the artifact to a shared directory.
- Ensures that builds do not interfere with each other and are environment-consistent.

## Final ISO Build Container
- After all packages are built, a dedicated container is launched to assemble the final ISO.
- The container includes all necessary build scripts and configuration files.
- Uses the collected `.art` package artifacts to populate the OS root filesystem.

## Dockerfile
- Defines the build environment (base image, required tools, user setup).
- Copies all necessary scripts and configs into the container context.

## Automation
- All container operations are managed by the main build script (`build_system.sh`).
