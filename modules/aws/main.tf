# S3 bucket
resource "aws_s3_bucket" "b" {
  bucket = "thereisnowaythisbucketalreadyexists"

  tags = {
    Name        = "My bucket"
    Environment = "development"
  }
}

resource "aws_s3_bucket_ownership_controls" "b_ownership_controls" {
  bucket = aws_s3_bucket.b.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "b_public_access_block" {
  bucket = aws_s3_bucket.b.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "b_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.b_ownership_controls,
    aws_s3_bucket_public_access_block.b_public_access_block
  ]

  bucket = aws_s3_bucket.b.id
  acl    = "public-read"

}

resource "aws_s3_bucket_policy" "b_policy" {
  depends_on = [
    aws_s3_bucket_public_access_block.b_public_access_block
  ]

  bucket = aws_s3_bucket.b.id
  policy = <<EOF
{
 "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": ["s3:GetObject"],
        "Resource": "arn:aws:s3:::thereisnowaythisbucketalreadyexists/*"
      }
    ]
}
EOF
}

resource "aws_s3_bucket_website_configuration" "b_website" {
  bucket = aws_s3_bucket.b.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Cloudfront
locals {
  s3_origin_id = "s3-my-webapp.example.com"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "s3-my-webapp.example.com"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "my-cloudfront"
  default_root_object = "website/index.html"

  #logging_config {
  #  include_cookies = false
  #  bucket          = "mylogs.s3.amazonaws.com"
  #  prefix          = "myprefix"
  #}

  #aliases = ["mywebsite.example.com", "s3-static-web-dev.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

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

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "development"
    Name        = "my-tag"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
