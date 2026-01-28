#!/usr/bin/env python3
"""
ArttulOS Custom Build Tool
- Unified build, test, and packaging for ArttulOS
- Handles multi-package-manager integration, documentation, and release
"""
import subprocess
import sys
import os
from typing import List, Optional, Tuple

BUILD_STEPS: List[Tuple[str, Optional[List[str]]]] = [
    ("Output package sources and stability ratings", ["bash", "package_sources.sh"]),
    ("Install Pacman packages", ["sudo", "pacman", "-Sy", "--noconfirm", "vim", "git", "cinnamon-desktop"]),
    ("Install RPM packages", None),  # Handled specially
    ("Install Nix packages", ["nix-env", "-iA", "nixpkgs.cinnamon", "nixpkgs.git", "nixpkgs.vim"]),
    ("Generate documentation and release version", ["bash", "generate_docs.sh"]),
    ("Build ISO", ["sudo", "livecd-creator", "--config=../configs/arttulos-ks.cfg", "--fslabel=ARTTULOS", "--cache=build/cache", "--tmpdir=build/tmp", "--releasever=8", "--title=ArttulOS 2026.01", "--verbose", "--resultdir=build"]),
    ("Move ISO to output", ["bash", "-c", "find build -name '*.iso' -exec mv {} ../arttulos-2026.01.iso ';'"])
]


def run_step(desc: str, cmd: Optional[List[str]]) -> None:
    print(f"\n=== {desc} ===")
    if desc == "Install RPM packages":
        # Check if rpm is available
        if subprocess.call(["which", "rpm"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) != 0:
            print("Warning: rpm not found, skipping RPM package installation.")
            return
        cmd = ["sudo", "rpm", "-i", "--test", "/home/builder/configs/rpm/*.rpm"]
    if cmd is None:
        print(f"No command for step: {desc}, skipping.")
        return
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error in step '{desc}': {e}")
        sys.exit(1)

def main():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    for desc, cmd in BUILD_STEPS:
        run_step(desc, cmd)
    print("\nBuild complete! ISO is ready.")

if __name__ == "__main__":
    main()


def clean_build() -> None:
    """Cleanup build artifacts and temporary directories."""
    # Implement a basic cleanup routine; keep it safe and local to project
    build_dirs = ["build", "build/cache", "build/tmp"]
    for d in build_dirs:
        path = os.path.join(os.path.dirname(os.path.abspath(__file__)), d)
        if os.path.exists(path):
            try:
                if os.path.isfile(path):
                    os.remove(path)
                else:
                    # remove directory contents
                    for root, dirs, files in os.walk(path, topdown=False):
                        for name in files:
                            os.remove(os.path.join(root, name))
                        for name in dirs:
                            os.rmdir(os.path.join(root, name))
                    os.rmdir(path)
            except Exception:
                # don't raise during cleanup
                pass