
output "application_gateway_public_ip_address" {
  value = azurerm_public_ip.app_gateway.ip_address
}
