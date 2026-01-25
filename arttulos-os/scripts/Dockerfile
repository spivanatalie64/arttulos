# ArttulOS ISO Builder Dockerfile (platform agnostic)
FROM registry.fedoraproject.org/fedora:38

# Install core build tools, all package managers
RUN dnf -y install \
    livecd-tools \
    sudo \
    passwd \
    rpm \
    git \
    curl \
    gnupg \
    zstd \
    python3-pip \
    pkgconf-pkg-config \
    parted \
    && dnf clean all

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
