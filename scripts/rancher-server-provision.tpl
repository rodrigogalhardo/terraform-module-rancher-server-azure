#!/usr/bin/env bash

set -x


# Start rancher server
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
 ${ssh_username}@${rancher_server_ip} -p ${ssh_port} \
 'sudo docker run --name=rancher -d --restart=unless-stopped -p ${rancher_server_port}:${rancher_server_port} \
 -e CATTLE_API_HOST=http://${rancher_server_ip}:${rancher_server_port} \
 -e DEFAULT_CATTLE_CATALOG_URL="{\"catalogs\":{\"nestle\":{\"url\":\"https://github.com/nespresso/rancher-custom-catalog.git\",\"branch\":\"master\"}}}" ${rancher_server_docker_image}'
