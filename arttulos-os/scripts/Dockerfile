# ArttulOS ISO Builder Dockerfile
FROM registry.fedoraproject.org/fedora:38

RUN dnf -y install livecd-tools sudo passwd \
    && dnf clean all

# Create build user
ENV USER=builder
RUN useradd -m $USER && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USER
WORKDIR /home/$USER

# Copy build scripts and configs
COPY --chown=builder:builder ../configs /home/$USER/configs
COPY --chown=builder:builder ./build_iso.sh /home/$USER/build_iso.sh
RUN chmod +x /home/$USER/build_iso.sh

CMD ["/home/builder/build_iso.sh"]
