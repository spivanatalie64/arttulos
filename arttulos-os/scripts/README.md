# ArttulOS Build Scripts

- `build_iso.sh`: Main script to build the ArttulOS ISO using the kickstart config.

## How to Build

1. Ensure you have `livecd-creator` and dependencies installed (see your distro docs).
2. Edit `../configs/arttulos-ks.cfg` to customize packages and post-install scripts.
3. Run:
   ```bash
   cd scripts
   sudo ./build_iso.sh
   ```
4. The resulting ISO will be in the project root as `arttulos-2026.01.iso`.

## Customization
- Add your own branding, packages, and post-install scripts in `../configs/` and `../branding/`.
