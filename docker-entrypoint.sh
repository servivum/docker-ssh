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
if ([ "$SSH_USER" ] && [ "$SSH_PASSWORD" ]); then
    adduser -D $SSH_USER
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
    echo "User ($SSH_USER) created."
else
    echo "No credentials given."
fi;

# Login with
if ([ "$SSH_ROOT_PUBLIC_KEY" ]); then
    mkdir -p ~/.ssh/
    touch ~/.ssh/authorized_keys
    echo "$SSH_ROOT_PUBLIC_KEY" > ~/.ssh/authorized_keys
    echo "Public key added to root user."
else
    echo "No SSH key given."
fi;

exec "$@"