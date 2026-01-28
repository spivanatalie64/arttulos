
# ArttulOS ISO Builder Dockerfile
FROM registry.fedoraproject.org/fedora:38


# Install core build tools and all package managers
RUN dnf -y install \
    livecd-tools \
    sudo \
    passwd \
    rpm \
    git \
    curl \
    gnupg \
    zstd \
    arch-install-scripts \
    && dnf clean all



# Download and extract Arch Linux bootstrap for chrooted Pacman
RUN curl -O https://geo.mirror.pkgbuild.com/iso/2026.01.01/archlinux-bootstrap-x86_64.tar.zst && \
    tar -I unzstd -xf archlinux-bootstrap-x86_64.tar.zst -C / && \
    mv /root.x86_64 /archroot && \
    rm archlinux-bootstrap-x86_64.tar.zst && \
    mkdir -p /archroot/proc /archroot/sys /archroot/dev
# Download and extract Arch Linux bootstrap tarball if /archroot is empty
RUN if [ ! -d /archroot ] || [ -z "$(ls -A /archroot 2>/dev/null)" ]; then \
    mkdir -p /archroot && \
    curl -O https://geo.mirror.pkgbuild.com/iso/2026.01.01/archlinux-bootstrap-x86_64.tar.zst && \
    tar -I unzstd -xf archlinux-bootstrap-x86_64.tar.zst -C / && \
    mv /root.x86_64/* /archroot/ && \
    rmdir /root.x86_64 && \
    rm archlinux-bootstrap-x86_64.tar.zst && \
    mkdir -p /archroot/proc /archroot/sys /archroot/dev; \
fi



# Update Pacman mirrorlist inside chroot
RUN echo 'Server = https://mirror.osbeck.com/archlinux/$repo/os/$arch' > /archroot/etc/pacman.d/mirrorlist



# Remove [community] repo from pacman.conf in chroot
RUN sed -i '/\[community\]/,/^$/d' /archroot/etc/pacman.conf



# Pacman keyring initialization moved to build_iso.sh for privileged runtime


# Install Nix package manager
RUN sh <(curl -L https://nixos.org/nix/install) --no-daemon || true


# Create build user
ENV USER=builder
RUN useradd -m $USER && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USER
WORKDIR /home/$USER


# Copy build scripts and configs (now in build context)
COPY --chown=builder:builder configs /home/$USER/configs
COPY --chown=builder:builder ./*.sh /home/$USER/
RUN chmod +x /home/$USER/*.sh

CMD ["/home/builder/build_iso.sh"]
