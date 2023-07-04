output "bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "S3 bucket ARN."
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_domain_name
  description = "S3 bucket URL."
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
  description = "S3 bucket region-specific URL."
}

