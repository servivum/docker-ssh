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

# Check if password or public key is given via file or env var.
if ([ -z "$SSH_PASSWORD" ] && [ -z "$SSH_PASSWORD_FILE" ] && [ -z "$SSH_PUBLIC_KEY" ] && [ -z "$SSH_PUBLIC_KEY_FILE" ]); then
    echo "No password or ssh public key defined"
    exit 2
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
else
    echo "Using public key defined in env var…"
    public_key="$SSH_PUBLIC_KEY"
fi

# Set home directory
home_dir_command=""
if [ "$user" == "root" ]; then
    home_dir="/root"
elif ([ "$user" != "root" ] && [ $SSH_HOME_DIR ]); then
    home_dir="$SSH_HOME_DIR"
    home_dir_command="-h $home_dir"
else
    home_dir="/home/$user"
fi

echo "My home dir: $home_dir"

# Create home directory
if [ ! -d "$home_dir" ]; then
    echo "Creating home directory: $home_dir"
    mkdir -p $SSH_HOME_DIR
else
    echo "Using default home directory /home/$user"
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

# Create public key folder if needed
if [ "$public_key" ]; then
    echo "Creating folder $home_dir/.ssh/"
    mkdir -p $home_dir/.ssh/
fi

# Create user
if ! id "$1" > /dev/null 2>&1; then
    echo "User ($user) created."
    adduser $password_command $home_dir_command $shell_command $user_id_command $user
fi

# Insert public keys
touch $home_dir/.ssh/authorized_keys
echo "$public_key" > $home_dir/.ssh/authorized_keys
chown -R $user:$user $home_dir/.ssh
chmod 0700 $home_dir/.ssh
chmod 0600 $home_dir/.ssh/authorized_keys
echo "Public key added"

# Set password
if [ "$password" ]; then
    echo "Setting password for user account…"
    echo "$user:$password" | chpasswd
else
    echo "Removing password…"
    passwd -d $user
fi

echo "Running sshd…"
exec "$@"