Rancher server module
===========

A terraform module to provide a rancher server in AZURE.
It requires an existing network.

Module Input Variables
----------------------

## required

- `docker_password` - Docker repository password
- `docker_repository` - Docker repository url
- `docker_username` - Docker repository username
- `rancher_dns_zone` - Rancher DNS Zone
- `rancher_dns_zone_resource_group` - Resource group in which the DNS Zone is
- `rancher_domain` - Rancher domain
- `rancher_reverse_proxy_docker_image` - Docker image name for Rancher server reverse proxy
- `rancher_sever_image_id` - Virtual Machine Image ID for Rancher server
- `rancher_ssl_certificate_file_path` - Rancher SSL certificate file path
- `rancher_ssl_key_file_path` - Rancher SSL key file path
- `resource_group_name` - Resource group name from Azure
- `security_group_name` - Security group name on which to add security rules
- `ssh_public_key_file_path` - Absolute path to public SSH key
- `ssh_private_key_file_path` - Absolute path to private SSH key
- `subnet_id` - Subnet ID where to put Rancher server
- `vnet_address_space` - The address space that is used the virtual network

## Optional

- `docker_insecure_registries` - List of Docker repository unsecure registries (Default = [])
- `location` - Azure location (Default = "West Europe")
- `rancher_docker_image` - Docker image name for Rancher server (Default = "rancher/server:stable")
- `rancher_server_name` - Rancher server name (Default = "server")
- `rancher_server_port` - Port on which Rancher server will listen (Default = 8080)
- `rancher_server_private_ip` - Rancher server private IP (Default = "10.3.1.4")
- `rancher_server_vm_size` - Rancher server VM size on Azure (Default = "Standard_DS1_v2")
- `resource_prefix_name` - Prefix to add on each resource name (Default = "")
- `ssh_username` - SSH username (Default = "rancher")

Usage
-----

```hcl
provider "azurerm" {
  subscription_id = "XXXX"
  client_id       = "XXXX"
  client_secret   = "XXXX"
  tenant_id       = "XXXX"
}

module "rancher_server" {
  source = "github.com/nespresso/terraform-module-rancher-server-azure"

  docker_password = "XXXXXXX"
  docker_repository = "docker.repository.url"
  docker_username = "docker_repository_username"
  rancher_dns_zone = "dsu.nestle.biz"
  rancher_dns_zone_resource_group = "resource-group-dns-zone"
  rancher_domain = "rancher"
  rancher_reverse_proxy_docker_image = "docker/image-reverse-proxy:latest"
  rancher_sever_image_id = "/subscriptions/XXXX/resourceGroups/resource-group/providers/Microsoft.Compute/images/Rancher-Image"
  rancher_ssl_certificate_file_path = "/file/path/to/cert.crt"
  rancher_ssl_key_file_path = "/file/path/to/ssl.key"
  resource_group_name = "resource-group"
  resource_prefix_name = "prefix"
  ssh_private_key_file_path = "/home/username/.ssh/id_rsa"
  ssh_public_key_file_path = "/home/username.ssh/id_rsa.pub"
  subnet_id = "/subscriptions/XXXX/resourceGroups/resource-group/providers/Microsoft.Network/virtualNetworks/prefix-vnet/subnets/prefix-subnet"
  user = "username"
}
```

Tested only with `Terraform v0.11.0` and `provider.azurerm v0.3.3`, which doesn't mean it won't work with other versions.

Outputs
=======

 - `rancher_api_url` - Rancher server API url
 - `rancher_server_ip` - Rancher server public IP

Authors
=======

- nicolas.cheutin@nestle.com
- valentin.delaye@nestle.com
