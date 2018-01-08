//Connection credentials to Azure API
variable "client_id" {
  description = "Client ID from Azure service principal"
}
variable "client_secret" {
  description = "Client secret from Azure service principal"
}
variable "tenant_id" {
  description = "Tenant ID from Azure service principal"
}
variable "subscription_id" {
  description = "Subscription ID from Azure subscription"
}

//Common
variable "resource_group_name" {
  description = "Resource group name from Azure"
}
variable "resource_prefix_name" {
  default = ""
  description = "Prefix to add on each resource name"
}
variable "location" {
  default = "West Europe"
  description = "Azure location"
}

//Rancher server
variable "rancher_sever_image_id" {
  description = "Virtual Machine Image ID for Rancher server"
}

variable "rancher_server_name" {
  default = "server" // Concatenated with ${var.resource_prefix_name}
  description = "Rancher server name"
}

// External DNS
variable "rancher_domain" {
  description = "The rancher domain for the DNS zone"
}

// DNS zone
variable "rancher_dns_zone" {
  description = "The rancher DNS zone"
}

variable "rancher_dns_zone_resource_group" {
  description = "The resource group for the DNS zone"
}

variable "docker_insecure_registries" {
  default = "[]",
  description = "List of insecure docker registries"
}

variable "rancher_docker_image" {
  default = "rancher/server:stable"
  description = "The rancher server image"
}

variable "rancher_reverse_proxy_docker_image" {
  description = "The rerverse proxy docker image"
}

variable "rancher_access_key" {
  description = "Rancher server API access key"
}

variable "rancher_secret_key" {
  description = "Rancher server API secret key"
}

variable "rancher_server_private_ip" {
  default = "10.3.1.4"
  description = "Rancher server private IP"
}

variable "rancher_server_vm_size" {
  default = "Standard_DS1_v2"
  description = "Rancher server VM size on Azure"
}

//User
variable "ssh_public_key_file_path" {
  description = "Absolute path to public SSH key"
}
variable "ssh_private_key_file_path" {
  description = "Absolute path to private SSH key"
}
variable "ssh_username" {
  default = "rancher"
  description = "SSH username"
}

// SSL certificate
variable "rancher_ssl_certificate_name" {
  default = "default"
}

variable "rancher_ssl_certificate_file_path" {}
variable "rancher_ssl_key_file_path" {}

//Network
variable "security_group_name" {
  description = "Security group name on which to add security rules"
}
variable "subnet_id" {
  description = "Subnet ID where to put Rancher server"
}

variable "vnet_address_space" {
  description = "The address space that is used the virtual network"
}
