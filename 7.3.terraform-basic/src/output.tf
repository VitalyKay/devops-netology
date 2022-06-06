#output "internal_ip_address_nodes" {
#  value = "${yandex_compute_instance.node[*].network_interface.0.ip_address}"
#}
#
#output "external_ip_address_nodes" {
#  value = "${yandex_compute_instance.node[*].network_interface.0.nat_ip_address}"
#}

output "internal_ip_address_nodes" {
  value = values(yandex_compute_instance.node-foreach)[*].network_interface.0.ip_address
}

output "external_ip_address_nodes" {
  value = values(yandex_compute_instance.node-foreach)[*].network_interface.0.nat_ip_address
}