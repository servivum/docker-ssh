#!/bin/bash
set -ev

echo "Building images…"
docker-compose -f docker-compose.build.yml build --no-cache --pull

# echo "Printing Docker version…"
# docker version

# echo "Building image…"
# docker build -t servivum/ssh .

# echo "Running image…"
# docker run -d -P --rm --name ssh \
#     -e "SSH_USER=john" \
#     -e "SSH_PASSWORD=doe" \
#     -e "SSH_PUBLIC_KEY=ssh-rsa abc test@example.com" \
#     servivum/ssh

# sleep 5

# echo "Checking if container is running…"
# docker ps | grep ssh

# echo "Checking existence of some binaries and packages…"
# docker exec ssh which sshd
# docker exec ssh ps aux | grep sshd

# echo "Getting IP address of external docker-machine or using localhost instead…"
# if ! docker-machine ip; then
#     export IP="127.0.0.1"
# else
#     export IP=$(docker-machine ip)
# fi
# echo "IP: $IP"

# export PORT=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' ssh)
# echo "PORT: $PORT"
# docker ps

# # @TODO: Add test for establishing connection over SSH

# echo "Stopping container…"
# docker stop ssh