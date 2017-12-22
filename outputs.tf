output "rancher_server_ip" {
  value = "${module.rancher_server_vm.rancher_server_ip}",
}

output "rancher_server_port" {
  value = "${var.rancher_server_port}"
}

output "rancher_api_url" {
  value = "http://${module.rancher_server_vm.rancher_server_ip}:${module.rancher_server_vm.rancher_server_port}"
}