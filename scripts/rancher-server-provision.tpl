#!/usr/bin/env bash

set -x

# Create file from templates
docker_compose=$(mktemp)
docker_daemon=$(mktemp)
echo '${docker_compose_content}' > ${docker_compose}
echo '${docker_daemon_json_content}' > ${docker_daemon}

# ssl certificates
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P ${ssh_port} ${rancher_ssl_key_file_path} \
 ${ssh_username}@${rancher_server_ip}:/etc/ssl/key.pem

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P ${ssh_port} ${rancher_ssl_certificate_file_path} \
 ${ssh_username}@${rancher_server_ip}:/etc/ssl/cert.crt

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P ${ssh_port} /tmp/docker-compose.yml \
 ${ssh_username}@${rancher_server_ip}:

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P ${ssh_port} /tmp/daemon.json \
  ${ssh_username}@${rancher_server_ip}:

# Move daemon json to docker
 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${ssh_port} ${ssh_username}@${rancher_server_ip} \
 'sudo cp daemon.json /etc/docker && sudo service docker restart'

# Install docker compose
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
 ${ssh_username}@${rancher_server_ip} -p ${ssh_port} \
 "sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
 && sudo chmod +x /usr/local/bin/docker-compose"

# Start rancher server
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
 ${ssh_username}@${rancher_server_ip} -p ${ssh_port} 'sudo /usr/local/bin/docker-compose pull && \
 sudo /usr/local/bin/docker-compose up -d'