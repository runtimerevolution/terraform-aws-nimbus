resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}

module "static_website_bucket" {
  source = "../s3_bucket"

  bucket_name        = "${var.solution_name}-static-website"
  bucket_policy_json = data.aws_iam_policy_document.bucket_policy_document.json

  depends_on = [aws_cloudfront_origin_access_identity.origin_access_identity]
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = module.static_website_bucket.bucket.bucket_regional_domain_name
    origin_id   = var.cloudfront_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.cloudfront_default_root_object

  logging_config {
    include_cookies = false
    bucket          = module.static_website_bucket.bucket.bucket_domain_name
    prefix          = "logs/"
  }

  aliases = []

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.cloudfront_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = var.cloudfront_price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
