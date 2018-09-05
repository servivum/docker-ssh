FROM alpine:3.7
LABEL maintainer "Patrick Baber <patrick.baber@servivum.com>"

# Install openssh-server
RUN apk add --no-cache openssh && \
    echo "Remove existing keys" && \
    rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["entrypoint.sh"]