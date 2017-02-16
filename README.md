![SSH-Server 7.2](https://img.shields.io/badge/SSH-7.2-brightgreen.svg?style=flat-square) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT) [![Travis](https://img.shields.io/travis/servivum/docker-ssh.svg?style=flat-square)](https://travis-ci.org/servivum/docker-ssh)

# SSH Server Docker Image

Dockerfile with SSH server based on a tiny Alpine Linux.

## Supported Tags

- `7.2`, `latest` [(Dockerfile)](https://github.com/servivum/docker-ssh)

## Log with Username and Password

Mount your public key into the container and define the path with 
environment variable `SSH_AUTHORIZED_KEYS`. Example:

```bash
docker container run -d -P -e "SSH_USER=john" -e "SSH_PASSWORD=doe" servivum/ssh
```
