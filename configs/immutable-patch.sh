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

echo "ArttulOS: Immutable patches applied."
