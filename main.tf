module "rancher_server_vm" {

  source = "github.com/nespresso/terraform-module-rancher-server-azure-vm"
  rancher_domain = "${var.rancher_domain}"
  rancher_dns_zone = "${var.rancher_dns_zone}"
  rancher_dns_zone_resource_group = "${var.rancher_dns_zone_resource_group}"
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

# Template file for docker daemon
data "template_file" "local-provision-script" {
  template = "${file("${path.module}/scripts/local-provision.sh.tpl")}"
  vars {
    docker_repository = "${var.docker_repository}"
    docker_username = "${var.docker_username}"
    docker_password = "${var.docker_password}"
    rancher_api_url = "${module.rancher_server_vm.rancher_api_url}"
  }
}

# Copy files and provision machine
resource "null_resource" "rancher-server-provision" {
  triggers {
    rancher_server_id = "${module.rancher_server_vm.rancher_server_id}"
  }

  connection {
    host = "${module.rancher_server_vm.rancher_server_ip}"
    private_key = "${file(var.ssh_private_key_file_path)}"
    type = "ssh"
    user = "${var.ssh_username}"
  }

  provisioner "file" {
    source = "${var.rancher_ssl_key_file_path}"
    destination = "/tmp/key.pem"
  }

  provisioner "file" {
    source = "${var.rancher_ssl_certificate_file_path}"
    destination = "/tmp/cert.crt"
  }

  provisioner "file" {
    content = "${data.template_file.rancher-server-docker-compose.rendered}"
    destination = "~/docker-compose.yml"
  }

  provisioner "file" {
    content = "${data.template_file.rancher-server-docker-daemon-json.rendered}"
    destination = "/tmp/daemon.json"
  }

  provisioner "file" {
    content = "${data.template_file.local-provision-script.rendered}"
    destination = "~/local-provision.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/cert.crt /tmp/key.pem /etc/ssl/",
      "sudo mv /tmp/daemon.json /etc/docker/daemon.json",
      "chmod +x ~/local-provision.sh",
      "~/local-provision.sh"
    ]
  }

  depends_on = [
    "data.template_file.rancher-server-docker-compose",
    "data.template_file.rancher-server-docker-daemon-json"
  ]
}
