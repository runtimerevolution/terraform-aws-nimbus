output "origin_access_identity" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity
  description = "CloudFront origin access identity."
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cloudfront_distribution.domain_name
  description = "Cloudfront distribution URL."
}
