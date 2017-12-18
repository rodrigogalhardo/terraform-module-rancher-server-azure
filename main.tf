# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

module "rancher_server_vm" {
  source = "github.com/nespresso/Terraform-module-Azure-VM-for-rancher-server"

  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  location = "${var.location}"
  rancher_sever_image_id = "${var.rancher_sever_image_id}"
  rancher_server_name = "${var.rancher_server_name}"
  rancher_server_port = "${var.rancher_server_port}"
  rancher_server_private_ip = "${var.rancher_server_private_ip}"
  rancher_server_vm_size = "${var.rancher_server_vm_size}"
  resource_group_name = "${var.resource_group_name}"
  resource_prefix_name = "${var.resource_prefix_name}"
  security_group_name = "${var.security_group_name}"
  ssh_public_key_file_path = "${var.ssh_public_key_file_path}"
  ssh_private_key_file_path = "${var.ssh_private_key_file_path}"
  ssh_username = "${var.ssh_username}"
  subnet_id = "${var.subnet_id}"
  subscription_id = "${var.subscription_id}"
  tenant_id = "${var.tenant_id}"
  vnet_address_space = "${var.vnet_address_space}"
}

resource "null_resource" "rancher-server-provision" {
  triggers {
    rancher_server_id = "${module.rancher_server_vm.rancher_server_id}"
  }

  connection {
    host = "${module.rancher_server_vm.rancher_server_public_ip}"
    private_key = "${file("${var.ssh_private_key_file_path}")}"
    type = "ssh"
    user = "${var.ssh_username}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run -d --restart=unless-stopped -p ${var.rancher_server_port}:${var.rancher_server_port} -e \"CATTLE_API_HOST=http://${module.rancher_server_vm.rancher_server_private_ip}:${var.rancher_server_port}\" rancher/server:stable",
    ]
  }
}
