output "static_website_bucket_endpoint" {
  value       = module.application_aws.static_website_bucket_endpoint
  description = "Static website S3 bucket URL."
}

output "load_balancer_endpoint" {
  value       = module.application_aws.load_balancer_endpoint
  description = "Load balancer URL."
}

output "cloudfront_endpoint" {
  value       = module.application_aws.cloudfront_endpoint
  description = "Cloudfront distribution URL."
}

output "databases_endpoints" {
  value       = module.application_aws.databases_endpoints
  description = "Databases URLs."
}
