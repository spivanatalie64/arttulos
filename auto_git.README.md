# Git Automation Script Usage

## Script: `auto_git.sh`
- Automates branch creation, add/commit/push, merge, and cleanup.
- Generates a commit message based on changed files.
- Usage: `./auto_git.sh <feature_name>`
  - Example: `./auto_git.sh update-docs`

## Integration
- Add the following line to the end of your build script (e.g., `build_system.sh`):

```bash
./auto_git.sh <feature_name>
```
- Replace `<feature_name>` with a short description of the change (e.g., `fix-artifact-format`).

## What it does
1. Creates a feature branch named `feature-<feature_name>-<timestamp>`
2. Adds and commits all changes with a generated message
3. Pushes the branch to origin
4. Merges the branch into `main` and pushes
5. Deletes the feature branch locally and remotely

## Notes
- Requires a clean working directory and remote named `origin`.
- Will skip commit if there are no changes.
- Can be run after each build for full automation.
