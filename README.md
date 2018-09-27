![SSH-Server 7.5](https://img.shields.io/badge/SSH-7.5-brightgreen.svg?style=flat-square) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT) [![Travis](https://img.shields.io/travis/servivum/docker-ssh.svg?style=flat-square)](https://travis-ci.org/servivum/docker-ssh)

# SSH Server Docker Image

Dockerfile with SSH server based on a tiny Alpine Linux.

## Supported Tags

- `7.5`, `latest` [(Dockerfile)](https://github.com/servivum/docker-ssh)

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