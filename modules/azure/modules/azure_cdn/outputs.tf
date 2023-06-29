output "azure_cdn_endpoint_domain_name" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}
