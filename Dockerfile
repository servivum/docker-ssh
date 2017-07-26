FROM alpine:3.5
LABEL maintainer "Patrick Baber <patrick.baber@servivum.com>"

# Install openssh-server
RUN apk add --update openssh \
    && rm  -rf /tmp/* /var/cache/apk/* && \

    # Remove existing keys
    rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]