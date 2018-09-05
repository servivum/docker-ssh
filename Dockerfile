FROM alpine:3.7
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
    echo "Preparing run direcotry for sshd…" && \
    mkdir -p /var/run/sshd

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["entrypoint.sh"]