FROM fedora

# Install systemd, openssh-server, and useful tools
RUN dnf -y install \
        systemd \
        systemd-libs \
        systemd-container \
        openssh-server \
        passwd \
        sudo \
        iproute \
        procps-ng \
        firewalld \
        python3 \
        python3-dnf \
    && dnf clean all \
    && ssh-keygen -A

# Enable root ssh login and password login
COPY sshd_config /etc/ssh/

# Enable sshd service
RUN mkdir -p /var/run/sshd && \
    systemctl enable sshd.service && \
    echo 'root:root' | chpasswd

# Expose ssh port
EXPOSE 22

# Systemd needs a few things mounted when container runs
VOLUME [ "/sys/fs/cgroup" ]

# Use systemd as PID 1
CMD ["/usr/sbin/init"]

