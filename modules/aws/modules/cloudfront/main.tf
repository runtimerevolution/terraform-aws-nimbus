resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {}

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

  static_website_origin_id = "s3"
  load_balancer_origin_id  = "lb"

  static_website_origin = var.static_website_url == null ? {} : {
    static_website_origin = {
      id          = local.static_website_origin_id
      domain_name = var.static_website_url
      s3_origin_config = {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      }
    }
  }

  load_balancer_origin = var.load_balancer_url == null ? {} : {
    load_balancer_origin = {
      id          = local.load_balancer_origin_id
      domain_name = var.load_balancer_url
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = var.acm_certificate_arn == null ? "http-only" : "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  origins = merge(local.static_website_origin, local.load_balancer_origin)
}

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
  dynamic "origin" {
    for_each = local.origins

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.id

      dynamic "s3_origin_config" {
        for_each = length(keys(lookup(origin.value, "s3_origin_config", {}))) == 0 ? [] : [lookup(origin.value, "s3_origin_config", {})]

        content {
          origin_access_identity = s3_origin_config.value.origin_access_identity
        }
      }

      dynamic "custom_origin_config" {
        for_each = length(keys(lookup(origin.value, "custom_origin_config", {}))) == 0 ? [] : [lookup(origin.value, "custom_origin_config", {})]

        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
        }
      }
    }
  }

  aliases = local.aliases

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.static_website_url != null ? var.cloudfront_static_website_root_object : null

  logging_config {
    include_cookies = false
    bucket          = module.bucket_cloudfront.bucket_domain_name
    prefix          = "logs/"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.static_website_url != null ? local.static_website_origin_id : local.load_balancer_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    default_ttl            = 3600
    min_ttl                = 0
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.path_patterns

    content {
      path_pattern     = ordered_cache_behavior.value
      allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = local.load_balancer_origin_id

      default_ttl = 0
      min_ttl     = 0
      max_ttl     = 0

      forwarded_values {
        query_string = true
        cookies {
          forward = "all"
        }
      }

      viewer_protocol_policy = "redirect-to-https"
    }
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
