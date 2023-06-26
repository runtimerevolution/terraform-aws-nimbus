output "container_app_environment_static_ip_address" {
  value = azurerm_container_app_environment.env.static_ip_address
}

output "container_app_fqdn" {
  value = azurerm_container_app.app.latest_revision_fqdn
}
