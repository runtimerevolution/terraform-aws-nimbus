output "static_website_bucket_endpoint" {
  value       = var.enable_static_website ? module.static_website_bucket[0].bucket.bucket_regional_domain_name : null
  description = "Static website S3 bucket URL."
}

output "load_balancer_endpoint" {
  value       = var.enable_ecs ? module.load_balancer[0].load_balancer_dns_name : null
  description = "Load balancer URL."
}

output "cloudfront_endpoint" {
  value       = module.cloudfront.cloudfront_domain_name
  description = "Cloudfront distribution URL."
}

output "databases_endpoints" {
  value       = length(var.databases) > 0 ? module.databases[0].databases_endpoints : null
  description = "Databases URLs."
}
