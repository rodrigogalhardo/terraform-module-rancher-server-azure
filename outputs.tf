output "rancher_server_ip" {
  value = "${module.rancher_server_vm.rancher_server_ip}",
}

output "rancher_api_url" {
  value = "${module.rancher_server_vm.rancher_api_url}"
}
