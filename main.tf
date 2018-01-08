# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

module "rancher_server_vm" {

  #source = "github.com/nespresso/terraform-module-rancher-server-azure-vm"
  source = "../terraform-module-rancher-server-azure-vm"
  rancher_domain = "${var.rancher_domain}"
  rancher_dns_zone = "${var.rancher_dns_zone}"
  rancher_dns_zone_resource_group = "${var.rancher_dns_zone_resource_group}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  location = "${var.location}"
  rancher_sever_image_id = "${var.rancher_sever_image_id}"
  rancher_server_name = "${var.rancher_server_name}"
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

# The template file for docker-compose
data "template_file" "rancher-server-docker-compose" {
  template = "${file("${path.module}/scripts/docker-compose.tpl")}"
  vars {
    rancher_fqdn = "${module.rancher_server_vm.rancher_fqdn}"
    rancher_api_url = "${module.rancher_server_vm.rancher_api_url}"
    rancher_server_docker_image = "${var.rancher_docker_image}"
    rancher_reverse_proxy_docker_image = "${var.rancher_reverse_proxy_docker_image}"
  }


}

# Template file for docker daemon
data "template_file" "rancher-server-docker-daemon-json" {
  template = "${file("${path.module}/scripts/daemon.json.tpl")}"
  vars {
    docker_insecure_registries = "${var.docker_insecure_registries}"
  }
}

# The template file for rancher server provisioning
data "template_file" "rancher-server-provision-script" {
  template = "${file("${path.module}/scripts/rancher-server-provision.tpl")}"
  vars {
    ssh_username = "${var.ssh_username}"
    ssh_port = "22"
    provision_script = "${file("${path.module}/scripts/local-provision.sh")}"
    rancher_server_ip = "${module.rancher_server_vm.rancher_server_ip}"
    docker_compose_content = "${data.template_file.rancher-server-docker-compose.rendered}"
    docker_daemon_json_content = "${data.template_file.rancher-server-docker-daemon-json.rendered}"
    rancher_ssl_key_file_path = "${var.rancher_ssl_key_file_path}"
    rancher_ssl_certificate_file_path = "${var.rancher_ssl_certificate_file_path}"
  }
}

resource "null_resource" "rancher-server-provision" {
  triggers {
    rancher_server_id = "${module.rancher_server_vm.rancher_server_id}"
  }

  provisioner "local-exec" {
    command = "echo ${data.template_file.rancher-server-provision-script.rendered}"
  }


  depends_on = [
    "data.template_file.rancher-server-provision-script",
    "data.template_file.rancher-server-docker-compose",
    "data.template_file.rancher-server-docker-daemon-json"
  ]
}
