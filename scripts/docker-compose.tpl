version: "3.1"

services:

  #
  # Rancher server
  #
  rancher:
    image: ${rancher_server_docker_image}
    restart: always
    container_name: rancher
    environment:
      - CATTLE_API_HOST=${rancher_api_url}
      - DEFAULT_CATTLE_CATALOG_URL={"catalogs":{"community":{"url":"https://github.com/rancher/community-catalog.git","branch":"master"},"nestle":{"url":"https://github.com/nespresso/rancher-custom-catalog.git","branch":"master"}, "library":{"url":"https://git.rancher.io/rancher-catalog.git","branch":"master"}}}
    expose:
      - 8080

  #
  # Reverse proxy SSL
  #
  nginx:
    image: ${rancher_reverse_proxy_docker_image}
    restart: always
    container_name: nginx
    volumes:
      - /etc/ssl/cert.crt:/etc/ssl/cert.crt
      - /etc/ssl/key.pem:/etc/ssl/key.pem
    environment:
      server_host: "${rancher_fqdn}"
      backend_host: "rancher"
      backend_port: 8080
    expose:
      - 80
      - 443
    ports:
      - "80:80"
      - "443:443"

#
# Networking
#
networks:
  default:
    driver: bridge
    driver_opts:
      com.docker.network.enable_ipv6: "false"
    ipam:
      driver: default
