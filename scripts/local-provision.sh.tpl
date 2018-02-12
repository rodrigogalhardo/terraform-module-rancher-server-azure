#!/usr/bin/env bash


# Install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
 && sudo chmod +x /usr/local/bin/docker-compose

# Install SSL certificates
#sudo mkdir -p /etc/ssl
#sudo mv ~/bundle.pem ~/cert.crt
#sudo mv ~/server-key.pem ~/key.pem
#sudo mv ~/cert.crt /etc/ssl/
#sudo mv ~/key.pem /etc/ssl/

# Install docker configuration
#sudo mv /scripts/daemon.json /etc/docker
sudo service docker restart

# Login on registry
sudo docker login -u ${docker_username} -p ${docker_password} ${docker_repository}

# Start rancher server composition
#cd /root/files/
sudo /usr/local/bin/docker-compose pull
sudo /usr/local/bin/docker-compose stop nginx && sudo /usr/local/bin/docker-compose rm nginx &&
sudo /usr/local/bin/docker-compose up -d

# Wait until Rancher server is started
until $(curl --output /dev/null --silent --head --fail ${rancher_api_url}); do
  printf '.'
  sleep 3
done
