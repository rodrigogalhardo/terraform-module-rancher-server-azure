Rancher server module
===========

A terraform module to provide a rancher server in AZURE.
It requires an existing network.

Module Input Variables
----------------------

## required

- `client_id` - Client ID from Azure service principal
- `client_secret` - Client secret from Azure service principal
- `rancher_sever_image_id` - Virtual Machine Image ID for Rancher server
- `resource_group_name` - Resource group name from Azure
- `security_group_name` - Security group name on which to add security rules
- `ssh_public_key_file_path` - Absolute path to public SSH key
- `ssh_private_key_file_path` - Absolute path to private SSH key
- `subnet_id` - Subnet ID where to put Rancher server
- `subscription_id` - Subscription ID from Azure subscription
- `tenant_id` - Tenant ID from Azure service principal
- `vnet_address_space` - The address space that is used the virtual network

## Optional

- `location` - Azure location (Default = "West Europe")
- `rancher_server_name` - Rancher server name (Default = "server")
- `rancher_server_port` - Port on which Rancher server will listen (Default = 8080)
- `rancher_server_private_ip` - Rancher server private IP (Default = "10.3.1.4")
- `rancher_server_vm_size` - Rancher server VM size on Azure (Default = "Standard_DS1_v2")
- `resource_prefix_name` - Prefix to add on each resource name (Default = "")
- `ssh_username` - SSH username (Default = "rancher")

Usage
-----

```hcl
module "rancher_server" {
  source = "path/to/module/module-rancher-server"

  client_id = "XXXX"
  client_secret = "XXXX"
  rancher_sever_image_id = "/subscriptions/XXXX/resourceGroups/resource-group/providers/Microsoft.Compute/images/Rancher-Image"
  resource_group_name = "resource-group"
  resource_prefix_name = "prefix"
  ssh_private_key_file_path = "/home/username/.ssh/id_rsa"
  ssh_public_key_file_path = "/home/username.ssh/id_rsa.pub"
  subnet_id = "/subscriptions/XXXX/resourceGroups/resource-group/providers/Microsoft.Network/virtualNetworks/prefix-vnet/subnets/prefix-subnet"
  subscription_id = "XXXX"
  tenant_id = "XXXX"
  user = "username"
}
```

Tested only with `Terraform v0.11.0` and `provider.azurerm v0.3.3`, which doesn't mean it won't work with other versions.

Outputs
=======

 - `rancher_server_public_ip` - Rancher server public IP
 - `rancher_server_private_ip` - Rancher server private IP
 - `rancher_server_port` - Rancher server port


Authors
=======

nicolas.cheutin@nestle.com