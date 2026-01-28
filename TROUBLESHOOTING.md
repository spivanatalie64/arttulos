# Troubleshooting and Common Errors

## Build Failures
- **Missing files in Docker context:** Ensure all required scripts and configs are present in the project root.
- **Invalid artifact format:** Package build scripts must create gzip-compressed tar archives (`.tar.gz`).
- **Extraction errors:** If `tar` or `gzip` fails, check the artifact format and contents.
- **Dependency issues:** Make sure all required tools are installed in the Dockerfile.

## Git Issues
- **Merge conflicts:** Resolve automatically or manually if needed.
- **Branch not found:** Ensure branches are created and pushed before merging.

## Automation Problems
- **Script errors:** Check logs for error messages and fix script logic as needed.
- **Container build failures:** Validate Dockerfile and build context.

## General Tips
- Always check logs for the exact error message.
- Validate artifact formats before running the ISO build.
- Keep the repository clean and organized.
