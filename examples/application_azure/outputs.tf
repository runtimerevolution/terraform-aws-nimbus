output "static_website_storage_account_endpoint" {
  value = module.terraform_multicloud_azure.static_website_storage_account_endpoint
}

output "cdn_endpoint" {
  value = module.terraform_multicloud_azure.cdn_endpoint
}

output "application_gateway_endpoint" {
  value = module.terraform_multicloud_azure.application_gateway_endpoint
}

output "container_apps_endpoints" {
  value = module.terraform_multicloud_azure.container_apps_endpoints
}
