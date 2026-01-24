import subprocess

# Example backend for installing apps from different sources

def install_pacman(pkg):
    return subprocess.run(['sudo', 'pacman', '-S', '--noconfirm', pkg])

def install_rpm(pkg):
    return subprocess.run(['sudo', 'dnf', 'install', '-y', pkg])

def install_nix(pkg):
    return subprocess.run(['nix-env', '-iA', f'nixpkgs.{pkg}'])

# Add logic to select best source and handle errors
