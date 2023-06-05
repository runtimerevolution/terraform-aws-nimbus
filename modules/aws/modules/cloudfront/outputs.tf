output "static_website_bucket" {
  value = module.static_website_bucket.bucket
}

output "cdn" {
  value = aws_cloudfront_distribution.cloudfront_distribution
}
