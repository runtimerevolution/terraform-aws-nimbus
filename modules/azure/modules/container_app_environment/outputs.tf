output "container_app_environment_static_ip_address" {
  value = azurerm_container_app_environment.env.static_ip_address
}

output "container_apps" {
  value = [for c in azurerm_container_app.app : { name = c.name, fqdn = c.latest_revision_fqdn, port = c.ingress[0].target_port }]
}
