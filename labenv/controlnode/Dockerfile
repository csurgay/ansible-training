FROM fedora:latest

# Doesn't install ansible, first excersice will

RUN dnf install -y \
    openssh-clients \
    sshd \
    openssh-server \
    passwd \
    python3 \
    python3-dnf && \
    dnf clean all && \
    echo "root:passwd" | chpasswd && \
    ssh-keygen -A

COPY sshd_config /etc/ssh/

RUN mkdir -p /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

