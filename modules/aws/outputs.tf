output "s3_static_website_bucket" {
  value = try(aws_s3_bucket.s3_bucket.bucket, "")
}