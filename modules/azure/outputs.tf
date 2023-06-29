output "static_website_storage_account_endpoint" {
  value = var.enable_static_website ? module.static_website[0].storage_account_web_host : null
}

output "cdn_endpoint" {
  value = var.enable_static_website || var.enable_application ? module.cdn[0].azure_cdn_endpoint_domain_name : null
}

output "application_gateway_endpoint" {
  value = var.enable_application ? module.application_gateway[0].application_gateway_public_ip_address : null
}

output "container_apps_endpoints" {
  value = var.enable_application ? [for c in module.container_app_environment[0].container_apps : "${c.fqdn}:${c.port}"] : null
}
