# Artifact Collection and Usage

## Artifact Directory: `artpkgs/`
- All package build containers output their `.art` files to this directory.
- The directory is used as the source for package installation during ISO assembly.

## Artifact Format
- Each artifact is a gzip-compressed tar archive (`.tar.gz`), named with the package (e.g., `hello.art`).
- Must contain all files to be installed for the package.

## Usage in ISO Build
- The ISO build script (`build_iso.sh`) iterates over all artifacts in `artpkgs/`.
- Each artifact is extracted into the root filesystem using the install script (`install_art_packages.sh`).

## Validation
- Artifacts are checked for correct format before installation.
- Errors in extraction (e.g., not a gzip archive) will cause the build to fail and must be fixed in the package build script.
