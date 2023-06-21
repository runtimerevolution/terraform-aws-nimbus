output "static_website_storage_account_endpoint" {
  value = module.terraform_multicloud_azure.static_website_storage_account_endpoint
}

output "cdn_endpoint" {
  value = module.terraform_multicloud_azure.cdn_endpoint
}
