![SSH-Server 7.2](https://img.shields.io/badge/SSH-7.2-brightgreen.svg?style=flat-square) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT) [![Travis](https://img.shields.io/travis/servivum/docker-ssh.svg?style=flat-square)](https://travis-ci.org/servivum/docker-ssh)

# SSH Server Docker Image

Dockerfile with SSH server based on a tiny Alpine Linux.

## Supported Tags

- `7.2`, `latest` [(Dockerfile)](https://github.com/servivum/docker-ssh)

## Login with Username and Password

```bash
docker container run -d -P -e "SSH_USER=john" -e "SSH_PASSWORD=doe" servivum/ssh
```

## Login with SSH Public Key

```bash
docker container run -d -P -e "SSH_ROOT_PUBLIC_KEY=ssh-rsa bla test@example.com" servivum/ssh
```