# Updated Build & Git Workflow

## Build System
- Uses `archinstall` to create a virtual Arch Linux install (no arch-chroot).
- Builds packages using the archinstall-generated image.
- Runs ISO build using this image.
- Automatically invokes `auto_git.sh` at the end of each build.

## Build System Cleanup
- After building, the system:
  - Removes temporary build artifacts and directories
  - Deletes unnecessary/merged branches except `main` and feature branches
  - Cleans up any recompile lists
  - Ensures only relevant packages are recompiled as needed
- All cleanup is fully automated at the end of the build script.

## Git Automation (`auto_git.sh`)
- Now checks for YOUR specific GPG key (`14DBD5F8A3447FB6`) and SSH key (`~/.ssh/id_ed25519`).
- Only pushes to remote and cleans up branches if BOTH are present.
- Otherwise, only local commit and merge are performed.

## How It Works
- GPG key is detected by key ID.
- SSH key is detected by file presence (`id_ed25519` and `id_ed25519.pub`).
- Commit message is generated automatically.

## Security: Key Hash Verification
- Your actual GPG and SSH keys are never exposed or pushed.
- The script uses local SHA-256 hashes of your key ID and SSH key files for verification.
- Only if the hashes match the locally stored reference, remote pushes are allowed.
- No sensitive key material is ever published or visible to others.

## Security
- Prevents accidental pushes if your keys are not present, ensuring only your authorized commits reach the remote.

## Integration
- The build script (`build_system.sh`) calls `auto_git.sh` after each run.
- No manual intervention required; remote pushes are gated by key detection for security.

## Usage
- Run your build script as usual. Git automation will only push if your keys are present.
- To force remote pushes, ensure your GPG and SSH keys are available in your environment.

## VM-based Archinstall Workflow
- Downloads the latest Arch Linux ISO and builds a custom image in a VM using automated archinstall.
- The resulting image is used for all package builds and ISO assembly.
- Ensures reproducibility and isolation for every build.

## Full VM Boot/Install/Build/Export Workflow
- Boots a VM from the downloaded Arch Linux ISO
- Runs archinstall to set up the installed system
- Reboots into the installed Arch system
- Compiles packages inside the VM and exports them to the build environment
- Uses exported packages for ISO assembly
- Ensures full isolation and reproducibility for every build

## Multi-Package Stability Selection
- After exporting Arch packages from the VM, the build system also builds RPM and Nix packages.
- All three package types are compared for stability using automated tests.
- The most stable package is selected for inclusion in the ISO.
- Selection results are logged for traceability.
