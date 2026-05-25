# ArttulOS Immutable Patch
# Run during ISO build to make AcreetionOS immutable

set -e

cat > /etc/fstab.arttulos << 'FSTAB'
# ArttulOS — immutable root filesystem
# Root is read-only. Transient files use overlayfs.
/dev/disk/by-label/ARTTULOS / ext4 ro,noatime 0 1
tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
tmpfs /var/log tmpfs defaults,noatime,mode=0755 0 0
overlay /etc overlay lower=/,upper=/etc-overlay,work=/etc-work,x-systemd.requires=/etc-overlay 0 0
overlay /var overlay lower=/,upper=/var-overlay,work=/var-work,x-systemd.requires=/var-overlay 0 0
FSTAB

# Set up overlay directories
mkdir -p /etc-overlay /etc-work /var-overlay /var-work

# Systemd service for first-boot overlay setup
cat > /etc/systemd/system/arttulos-overlay-setup.service << 'SVC'
[Unit]
Description=ArttulOS overlay filesystem setup
DefaultDependencies=no
Before=local-fs.target
Requires=systemd-udevd.service
After=systemd-udevd.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/lib/arttulos/setup-overlays.sh

[Install]
WantedBy=local-fs.target
SVC

mkdir -p /usr/lib/arttulos
cat > /usr/lib/arttulos/setup-overlays.sh << 'OVERLAY'
#!/bin/bash
# Set up overlay filesystems for /etc and /var
mkdir -p /etc-overlay /etc-work /var-overlay /var-work
# Copy existing content into overlays on first boot
if [ ! -f /etc-overlay/.initialized ]; then
  cp -a /etc/* /etc-overlay/ 2>/dev/null || true
  cp -a /var/* /var-overlay/ 2>/dev/null || true
  touch /etc-overlay/.initialized
  touch /var-overlay/.initialized
fi
OVERLAY
chmod +x /usr/lib/arttulos/setup-overlays.sh

# Atomic update script
cat > /usr/bin/arttulos-update << 'UPDATE'
#!/bin/bash
# ArttulOS atomic update
# Downloads and applies A/B image updates
set -e
echo "ArttulOS: Checking for updates..."
# In alpha — will pull from R2 bucket when ready
echo "ArttulOS: Your system is up to date (alpha)."
UPDATE
chmod +x /usr/bin/arttulos-update

# Read-only /usr protection
cat > /etc/systemd/system/arttulos-usr-remount.service << 'RMTAB'
[Unit]
Description=Remount /usr as read-only
DefaultDependencies=no
Before=local-fs.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/mount -o remount,ro /usr

[Install]
WantedBy=local-fs.target
RMTAB

# Container runtime defaults
mkdir -p /etc/containers
cat > /etc/containers/storage.conf << 'STORAGE'
[storage]
driver = "overlay"
runroot = "/run/containers/storage"
graphroot = "/var/lib/containers/storage"
STORAGE

# ── Recovery Partition ──
# Creates a recovery partition that reinstalls the immutable base from R2

cat > /usr/lib/arttulos/recovery-setup.sh << 'RECOVERY'
#!/bin/bash
# ArttulOS recovery partition setup
# Called during first boot to create the recovery environment
set -e
RECOVERY_MNT="/recovery"
RECOVERY_LABEL="ARTTULOS_RECOVERY"
RECOVERY_IMG="/usr/lib/arttulos/recovery.img"

if [ -f "$RECOVERY_IMG" ]; then
  mkdir -p "$RECOVERY_MNT"
  # Mount recovery image (squashfs containing minimal kernel + tools)
  mount -o loop,ro "$RECOVERY_IMG" "$RECOVERY_MNT" 2>/dev/null || true
  echo "ArttulOS: Recovery partition mounted."
fi
RECOVERY
chmod +x /usr/lib/arttulos/recovery-setup.sh

# Recovery mode boot entry for systemd-boot
mkdir -p /boot/loader/entries
cat > /boot/loader/entries/arttulos-recovery.conf << 'BOOTENTRY'
title   ArttulOS Recovery
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=LABEL=ARTTULOS_RECOVERY ro rd.shell rd.debug loglevel=3
BOOTENTRY

# Recovery reinstall script (pulls base image from R2)
cat > /usr/bin/arttulos-recover << 'RECOVER'
#!/bin/bash
# ArttulOS — reinstall the immutable base from recovery
# This reinstalls the core OS files while preserving /home and overlays
set -e
echo "ArttulOS Recovery — Reinstalling base system..."
echo "This will replace all system files. Your data in /home is preserved."
echo ""
echo "Downloading latest base image from Cloudflare R2..."
BASE_URL="https://pub-00000000000000000000000000000000.r2.dev/arttulos/base.squashfs"
# In alpha: prints instructions
echo "Recovery: Download from $BASE_URL"
echo "Recovery: Apply with: unsquashfs -f -d / base.squashfs"
echo ""
echo "Then reboot. Your system will be fresh and your /home untouched."
RECOVER
chmod +x /usr/bin/arttulos-recover

# Systemd service to offer recovery mode at boot if system fails
cat > /etc/systemd/system/arttulos-boot-check.service << 'BOOTCHECK'
[Unit]
Description=ArttulOS boot health check
DefaultDependencies=no
Before=local-fs.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/lib/arttulos/boot-check.sh

[Install]
WantedBy=local-fs.target
BOOTCHECK

cat > /usr/lib/arttulos/boot-check.sh << 'BOOTCHECKSH'
#!/bin/bash
# Check if this is a successful boot after an update
# If boot fails 3 times in a row, offer recovery
MARK_FILE="/var-overlay/.arttulos-boot-ok"
if [ -f /var-overlay/.arttulos-boot-fail ]; then
  COUNT=$(cat /var-overlay/.arttulos-boot-fail)
  COUNT=$((COUNT + 1))
  if [ "$COUNT" -ge 3 ]; then
    echo "ArttulOS: Multiple boot failures detected."
    echo "ArttulOS: Boot into recovery mode to reinstall the base system."
    echo "ArttulOS: Run 'arttulos-recover' from the recovery shell."
    echo "$COUNT" > /var-overlay/.arttulos-boot-fail
  else
    echo "$COUNT" > /var-overlay/.arttulos-boot-fail
  fi
else
  echo "1" > /var-overlay/.arttulos-boot-fail
fi
[ -f "$MARK_FILE" ] && rm -f /var-overlay/.arttulos-boot-fail
BOOTCHECKSH
chmod +x /usr/lib/arttulos/boot-check.sh

# Mark successful boot service
cat > /etc/systemd/system/arttulos-boot-ok.service << 'BOOTOK'
[Unit]
Description=ArttulOS mark successful boot
After=local-fs.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/touch /var-overlay/.arttulos-boot-ok

[Install]
WantedBy=multi-user.target
BOOTOK

echo "ArttulOS: Immutable patches + recovery partition applied."
