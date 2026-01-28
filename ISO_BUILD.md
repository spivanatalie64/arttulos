# ISO Build and Export

## ISO Build Script: `build_iso.sh`
- Runs inside the final build container.
- Installs all `.art` package artifacts into the root filesystem.
- Uses `install_art_packages.sh` to extract each package.
- Assembles the final ISO image using standard tools (e.g., `livecd-tools`, `arch-install-scripts`).

## Output
- The completed ISO is exported to the designated output directory.
- Logs and build artifacts are retained for debugging and validation.

## Error Handling
- Any failure in package extraction or ISO assembly will halt the build and print an error message.
- Common errors include invalid artifact format or missing dependencies.
