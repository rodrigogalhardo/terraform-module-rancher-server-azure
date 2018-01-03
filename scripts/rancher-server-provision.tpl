#!/usr/bin/env bash

set -x

# Install rancher compose
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
 ${ssh_username}@${rancher_server_ip} -p ${ssh_port} \
 "sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
 && sudo chmod +x /usr/local/bin/docker-compose"

# Start rancher server
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
 ${ssh_username}@${rancher_server_ip} -p ${ssh_port} 'sudo /usr/local/bin/docker-compose up -d'