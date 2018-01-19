#!/usr/bin/env bash

set -x

# Create file from templates

echo "Creating temporatry files..."

temp_folder=$(mktemp -d)
echo '${docker_compose_content}' > $temp_folder/docker-compose.yml
echo '${docker_daemon_json_content}' > $temp_folder/daemon.json
echo '${provision_script_content}' > $temp_folder/local-provision.sh

# Copy files to remote

echo "Copy files to remote..."
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P ${ssh_port} \
 ${rancher_ssl_key_file_path} ${rancher_ssl_certificate_file_path} \
 $temp_folder/local-provision.sh $temp_folder/daemon.json $temp_folder/docker-compose.yml \
 ${ssh_username}@${rancher_server_ip}:

# Provision docker server
echo "Run provision script.."

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${ssh_port} ${ssh_username}@${rancher_server_ip} \
 'chmod +x ~/local-provision.sh && ~/local-provision.sh'
