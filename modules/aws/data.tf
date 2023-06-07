data "aws_iam_policy_document" "static_website_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.static_website_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [module.cloudfront.origin_access_identity.iam_arn]
    }
  }
}
