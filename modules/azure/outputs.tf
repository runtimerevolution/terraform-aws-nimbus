output "static_website_storage_account_endpoint" {
  value = module.static_website.storage_account_web_host
}

output "cdn_endpoint" {
  value = module.cdn.azure_cdn_endpoint_domain_name
}

output "application_gateway_endpoint" {
  value = module.application_gateway.application_gateway_public_ip_address
}
