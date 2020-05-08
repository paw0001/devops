output "myapp_internal_ip" {
    value = "${google_compute_instance.app.*.network_interface.0.network_ip}"
}
output "myapp_external_ip" {
    value = "${google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip}"
}

