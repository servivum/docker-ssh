# SSH Server Docker Image

Dockerfile with SSH server based on a tiny Alpine Linux and if needed, preinstalled with common utilities.

## Supported Tags

- `8.8`, [(Dockerfile)](https://github.com/servivum/docker-ssh/blob/master/8.8/Dockerfile)
- `8.8-common` [(Dockerfile)](https://github.com/servivum/docker-ssh/blob/master/8.8-common/Dockerfile)
- `7.5`, [(Dockerfile)](https://github.com/servivum/docker-ssh/blob/master/7.5/Dockerfile)
- `7.5-common` [(Dockerfile)](https://github.com/servivum/docker-ssh/blob/master/7.5-common/Dockerfile)

## Login with Username and Password

```bash
docker container run -d -P \
    -e "SSH_USER=john" \
    -e "SSH_PASSWORD=doe" \
    servivum/ssh
```

## Login with SSH Public Key

```bash
docker container run -d -P \
    -e "SSH_USER=john" \
    -e "SSH_PUBLIC_KEY=ssh-rsa bla test@example.com" \
    servivum/ssh
```

## All environment variables

```bash
docker container run -d -P \
    -e "SSH_USER=john" \
    -e "SSH_USER_FILE=/run/secrets/ssh_user" \
    -e "SSH_PASSWORD=doe" \
    -e "SSH_PASSWORD_FILE=/run/secrets/ssh_password" \
    -e "SSH_PUBLIC_KEY=ssh bla" \
    -e "SSH_PUBLIC_KEY_FILE=/run/secrets/authorized_keys" \
    -e "SSH_HOME_DIR=/var/www" \
    -e "SSH_CHOWN_HOME_DIR=true" \
    -e "SSH_SHELL=/bin/bash" \
    -e "SSH_USER_ID=99" \
    -e "SSH_GROUP_ID=101" \
    servivum/ssh
```

# Multi platform builds

```
export TAG="8.8-common"
docker buildx create --use
docker buildx build \
    --file ./$TAG/Dockerfile \
    --platform linux/amd64,linux/arm64/v8 \
    --tag servivum/ssh:$TAG \
    --push \
    $TAG/
```