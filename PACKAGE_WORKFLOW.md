# Package Build Workflow

## Package Structure
- Each package resides in its own subdirectory under `packages/`.
- Each package must provide a `build.sh` script.

## Build Script Requirements
- The build script must create a valid `.tar.gz` archive as the package artifact (e.g., `hello.art`).
- The archive should contain all files to be installed by the package.
- Example (hello package):
  - Creates a `hello.txt` file.
  - Archives it as `hello.art` using `tar -czf`.

## Build Execution
- The main build system runs each package's build script in a dedicated Docker container.
- Output artifacts are collected in `/output` and moved to the shared `artpkgs/` directory.

## Artifact Format
- Artifacts must be gzip-compressed tar archives for compatibility with the install script.
