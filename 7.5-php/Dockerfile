FROM servivum/php:7.2-fpm-alpine-common
LABEL maintainer "Patrick Baber <patrick.baber@servivum.com>"

# Install openssh-server
RUN apk add --no-cache \
    bash \
    openssh \
    && \
    echo "Removing existing keys…" && \
    rm -rf \
    /etc/ssh/ssh_host_dsa_key \
    /etc/ssh/ssh_host_ecdsa_key \
    /etc/ssh/ssh_host_ed25519_key \
    /etc/ssh/ssh_host_rsa_key \
    && \
    echo "Replacing host key paths…" && \
    mkdir -p /etc/ssh/host_keys && \
    sed -i 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/host_keys\/rsa_key/g' /etc/ssh/sshd_config && \
    sed -i 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/host_keys\/dsa_key/g' /etc/ssh/sshd_config && \
    sed -i 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/host_keys\/ecdsa_key/g' /etc/ssh/sshd_config && \
    sed -i 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/host_keys\/ed25519_key/g' /etc/ssh/sshd_config && \
    echo "Preparing run direcotry for sshd…" && \
    mkdir -p /var/run/sshd

COPY etc/motd /etc/motd
COPY usr/local/bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Install additional packages
RUN apk add --no-cache \
    curl \
    git \
    iputils \
    mc \
    mysql-client \
    nano \
    rsync \
    unzip \
    vim

# Install Composer
COPY --from=composer /usr/bin/composer /usr/local/bin/composer

VOLUME /etc/ssh/host_keys/
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["docker-entrypoint.sh"]