locals {
  certificate = {
    cloudfront_default_certificate = !var.enable_custom_domain
    acm_certificate_arn            = var.enable_custom_domain ? var.acm_certificate_arn : null

    # As recommended in the AWS documentation, when using custom domains set 
    # 'ssl_support_method' as 'sni-only' to accept HTTPS connections only from 
    # browsers and clients that support server name indication, which most do.
    ssl_support_method = var.enable_custom_domain ? "sni-only" : null
  }

  aliases = var.enable_custom_domain ? [var.domain, "www.${var.domain}"] : []
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}

# -----------------------------------------------------------------------------
# Create a S3 bucket to store logs
# -----------------------------------------------------------------------------
module "bucket_cloudfront" {
  source = "../s3_bucket"

  bucket_name        = "${var.solution_name}-cloudfront"
  bucket_acl         = "log-delivery-write"
  bucket_policy_json = data.aws_iam_policy_document.logging_bucket.json
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = var.public_dns
    origin_id   = var.public_dns

    # s3_origin_config {
    #   origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    # }

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = var.acm_certificate_arn == null ? "http-only" : "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  aliases = local.aliases

  enabled         = true
  is_ipv6_enabled = true
  default_root_object = var.cloudfront_static_website_root_object

  logging_config {
    include_cookies = false
    bucket          = module.bucket_cloudfront.bucket.bucket_domain_name
    prefix          = "logs/"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.public_dns

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
    cloudfront_default_certificate = local.certificate.cloudfront_default_certificate
    acm_certificate_arn            = local.certificate.acm_certificate_arn
    ssl_support_method             = local.certificate.ssl_support_method
  }
}

# -----------------------------------------------------------------------------
# Create a alias for the distribution in Route53
# -----------------------------------------------------------------------------
resource "aws_route53_record" "alias" {
  for_each = toset(local.aliases)

  zone_id = var.route53_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
