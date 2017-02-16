#!/bin/sh

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
    echo "Generating RSA key ..."
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi

if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
    echo "Generating DSA key ..."
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

# Prepare run dir
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
fi

# Create user and set password
if ([ "$SSH_USER" ] || [ "$SSH_PASSWORD" ]); then
    adduser -D $SSH_USER
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
fi;

exec "$@"