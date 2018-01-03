#!/usr/bin/env bash

set -x

# Copy files
echo '${docker_compose_content}' > /tmp/docker-compose.yml

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P ${ssh_port} /tmp/docker-compose.yml \
 ${ssh_username}@${rancher_server_ip}: