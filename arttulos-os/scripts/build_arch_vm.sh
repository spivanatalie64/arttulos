#!/bin/bash
# Full VM-based Arch Linux build and export workflow
set -e

ARCHISO_URL="https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso"
ARCHISO_PATH="/tmp/archlinux-x86_64.iso"
VM_DISK="/tmp/archinstall-vm-disk.qcow2"
VM_NAME="arttulos-archinstall"
VM_RAM=2048
VM_CPUS=2
VM_SSH_PORT=2222

# Download latest Arch ISO if not present
if [ ! -f "$ARCHISO_PATH" ]; then
    echo "Downloading Arch Linux ISO..."
    curl -L "$ARCHISO_URL" -o "$ARCHISO_PATH"
fi

# Create VM disk
if [ -f "$VM_DISK" ]; then
    rm -f "$VM_DISK"
fi
qemu-img create -f qcow2 "$VM_DISK" 20G

# Prepare custom archinstall profile for automated package build environment
ARCHINSTALL_PROFILE="/tmp/arttulos-archinstall-profile.json"
cat > "$ARCHINSTALL_PROFILE" <<EOF
{
  "profile": "minimal",
  "disk_config": [{
    "device": "/dev/vda",
    "wipe": true,
    "partitions": [{
      "mountpoint": "/",
      "size": null,
      "filesystem": "ext4"
    }]
  }],
  "bootloader": "systemd-boot",
  "hostname": "arttulos-build",
  "users": [{
    "name": "builder",
    "password": "builder",
    "groups": ["wheel"]
  }],
  "root_password": "root",
  "packages": ["base", "base-devel", "git", "vim", "sudo", "openssh", "arch-install-scripts", "pacman", "make", "gcc"]
}
EOF

# Launch QEMU with GUI for Arch install and monitor for keystroke injection
qemu-system-x86_64 \
    -m $VM_RAM \
    -smp $VM_CPUS \
    -name "ArttulOS Arch Install" \
    -cdrom "$ARCHISO_PATH" \
    -drive file="$VM_DISK",format=qcow2 \
    -boot d \
    -net user \
    -net nic \
    -vga virtio \
    -display default \
    -enable-kvm \
    -monitor unix:/tmp/qemu-monitor-socket,server,nowait &

# Wait for VM to boot (adjust as needed)
sleep 10

# Inject keystrokes to automate Arch install with custom profile
send_qemu_key() {
  echo "sendkey $1" | socat - UNIX-CONNECT:/tmp/qemu-monitor-socket
}
# Login as root
for k in r o o t enter; do send_qemu_key $k; done
# Run archinstall with custom profile
for k in a r c h i n s t a l l space - - c o n f i g space / t m p / a r t t u l o s - a r c h i n s t a l l - p r o f i l e . j s o n enter; do send_qemu_key $k; done

# After archinstall, reboot into installed system
qemu-system-x86_64 \
    -m $VM_RAM \
    -smp $VM_CPUS \
    -name "$VM_NAME" \
    -drive file="$VM_DISK",format=qcow2 \
    -nographic \
    -boot c \
    -net user,hostfwd=tcp::${VM_SSH_PORT}-:22 \
    -net nic &
VM_PID=$!

# Wait for SSH to become available
until nc -z localhost $VM_SSH_PORT; do sleep 2; done

# Check for zenity, install locally if missing (no root required)
if ! command -v zenity >/dev/null 2>&1; then
  echo "Zenity not found. Installing locally..."
  mkdir -p "$HOME/.local/bin"
  curl -L https://github.com/GNOME/zenity/releases/download/3.44.0/zenity-3.44.0.tar.xz -o /tmp/zenity.tar.xz
  tar -xf /tmp/zenity.tar.xz -C /tmp
  cd /tmp/zenity-3.44.0
  ./configure --prefix=$HOME/.local
  make
  make install
  ln -sf $HOME/.local/bin/zenity "$HOME/.local/bin/zenity"
  export PATH="$HOME/.local/bin:$PATH"
  echo "Zenity installed to $HOME/.local/bin"
fi

# OS-agnostic GUI VM manager launch for Arch install
if ! command -v virt-manager >/dev/null 2>&1; then
  echo "virt-manager not found. Attempting OS-agnostic install..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux: try flatpak or AppImage
    if command -v flatpak >/dev/null 2>&1; then
      flatpak install -y flathub org.virt_manager.virt-manager || true
      flatpak run org.virt_manager.virt-manager &
    else
      echo "Please install virt-manager via your package manager, Flatpak, or AppImage."
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: try Homebrew
    if command -v brew >/dev/null 2>&1; then
      brew install virt-manager || true
      open -a virt-manager
    else
      echo "Please install Homebrew and then virt-manager: brew install virt-manager."
    fi
  elif [[ "$OSTYPE" == "cygwin"* || "$OSTYPE" == "msys"* || "$OSTYPE" == "win32" ]]; then
    # Windows: suggest WSL or a Windows VM manager
    echo "On Windows, use WSL2 with a Linux GUI, or a VM manager like VirtualBox or QEMU GUI."
  else
    echo "Unknown OS. Please install a GUI VM manager (virt-manager, VirtualBox, QEMU GUI) manually."
  fi
else
  nohup virt-manager &
fi

echo "Please use your GUI VM manager to create and manage your Arch Linux VM. Once installed, continue with package compilation and export."

# Compile packages inside the VM (using SSH)
# Show logs and GUI status bar, do not show VM
scp -P $VM_SSH_PORT -r ./packages/* root@localhost:/root/packages/
for pkg in ./packages/*; do
  pkg_name=$(basename "$pkg")
  echo "Compiling $pkg_name in VM..."
  # Start GUI status bar with verbose log window (requires zenity)
  (zenity --progress --title="Compiling $pkg_name" --text="Building $pkg_name in VM..." --percentage=0 --auto-close &)
  ssh -p $VM_SSH_PORT root@localhost "cd /root/packages/$pkg_name && bash -x build.sh /root/output" | tee "build_logs/${pkg_name}_vm.log" &
  zenity --text-info --title="Verbose Log: $pkg_name" --filename="build_logs/${pkg_name}_vm.log" --width=800 --height=600 &
  wait
  pkill -f 'zenity --progress --title="Compiling'
  echo "Finished $pkg_name. Log: build_logs/${pkg_name}_vm.log"
done
scp -P $VM_SSH_PORT root@localhost:/root/output/* ./built_packages/

# Shutdown VM
kill $VM_PID

# Artifacts are now exported to ./built_packages for ISO build

echo "Packages compiled in VM and exported to build environment. Ready for ISO build."
