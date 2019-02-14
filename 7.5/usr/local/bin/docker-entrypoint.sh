#!/bin/sh

echo "Configuring sshd…"

# Create host keys
if [ ! -f "/etc/ssh/host_keys/dsa_key" ]; then
    echo "Generating DSA key…"
	ssh-keygen -f /etc/ssh/host_keys/dsa_key -N '' -t dsa
fi
if [ ! -f "/etc/ssh/host_keys/ecdsa_key" ]; then
    echo "Generating ECDSA key…"
	ssh-keygen -f /etc/ssh/host_keys/ecdsa_key -N '' -t ecdsa
fi
if [ ! -f "/etc/ssh/host_keys/ed25519_key" ]; then
    echo "Generating ED25519 key…"
	ssh-keygen -f /etc/ssh/host_keys/ed25519_key -N '' -t dsa
fi
if [ ! -f "/etc/ssh/host_keys/rsa_key" ]; then
    echo "Generating RSA key…"
	ssh-keygen -f /etc/ssh/host_keys/rsa_key -N '' -t rsa
fi

# Use user from file or env var or use root user
if [ "$SSH_USER_FILE" ]; then
    echo "Using user defined in file…"
    user=$(cat $SSH_USER_FILE)
elif [ "$SSH_USER" ]; then
    echo "Using user defined in env var…"
    user="$SSH_USER"
else
    echo "Using root user…"
    user="root"
fi

# Use password from file or env var
password_command=""
if [ "$SSH_PASSWORD_FILE" ]; then
    echo "Using password defined in file…"
    password=$(cat $SSH_PASSWORD_FILE)
elif [ "$SSH_PASSWORD" ]; then
    echo "Using password defined in env var…"
    password="$SSH_PASSWORD"
else
    echo "Disabling password authentication…"
    password_command="-D"
fi

# Use public key from file or env var
if [ "$SSH_PUBLIC_KEY_FILE" ]; then
    echo "Using public key defined in file…"
    public_key=$(cat $SSH_PUBLIC_KEY_FILE)
elif [ "$SSH_PUBLIC_KEY" ]; then
    echo "Using public key defined in env var…"
    public_key="$SSH_PASSWORD"
else
    echo "Skipping public key authentication…"
fi

# Set shell if defined
if [ "$SSH_SHELL" ]; then
    echo "Using $SSH_SHELL as user shell…"
    shell="$SSH_SHELL"
else
    echo "Using /bin/sh as user shell…"
    shell="/bin/sh"
fi
shell_command="-s $shell"

# Set user ID
if [ "$SSH_USER_ID" ]; then
    echo "Using user ID $SSH_USER_ID…"
    user_id_command="-u $SSH_USER_ID"
else
    echo "No user ID set"
    user_id_command=""
fi

# Use custom home directory
home_dir_command=""
if [ "$user" == "root" ]; then
    home_dir="/root"
elif ([ "$user" != "root" ] && [ $SSH_HOME_DIR ]); then
    home_dir="$SSH_HOME_DIR"
    home_dir_command="-h $home_dir"
else
    home_dir="/home/$user"
fi

# Create home directory
if [ ! -d "$home_dir" ]; then
    echo "Creating home directory: $home_dir"
    mkdir -p $home_dir
    mkdir -p $home_dir/.ssh/
else
    echo "Using default home directory /home/$user"
fi

# Place public keys in home folder
if [ "$public_key" ]; then
    echo "Creating folder $home_dir/.ssh/"
    mkdir -p $home_dir/.ssh/
    touch $home_dir/.ssh/authorized_keys
    echo "$public_key" > $home_dir/.ssh/authorized_keys
    chmod 0700 $home_dir/.ssh
    chmod 0600 $home_dir/.ssh/authorized_keys
    echo "Public key added"
fi

# Create group
group_id_command=""
if [ "$SSH_GROUP_ID" ]; then
    echo "Using group ID $SSH_GROUP_ID…"
    addgroup -g $SSH_GROUP_ID $user
    group_id_command="-G $user"
fi

# Create user
if ! id "$1" > /dev/null 2>&1; then
    echo "User ($user) created."
    adduser $password_command $home_dir_command $shell_command $user_id_command $group_id_command $user
fi

# Change owner .ssh directory
if [ "$SSH_GROUP_ID" ]; then
    chown -R $user:$user $home_dir/.ssh
else
    chown -R $user $home_dir/.ssh
fi

# Set password
if [ "$password" ]; then
    echo "Setting password for user account…"
    echo "$user:$password" | chpasswd
else
    echo "Removing password…"
    passwd -d $user
fi

# Change owner of home dir
if [ "$SSH_CHOWN_HOME_DIR" ]; then
    echo "Changing owner of home dir…"
    if [ "$SSH_GROUP_ID" ]; then
        chown -R $user:$user $home_dir
    else
        chown -R $user $home_dir
    fi
fi

echo "Running sshd…"
exec "$@"