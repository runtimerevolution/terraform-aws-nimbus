data "aws_iam_policy_document" "static_website_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = var.enable_static_website ? ["${module.static_website_bucket[0].bucket.arn}/*"] : []

    principals {
      type        = "AWS"
      identifiers = [module.cloudfront.origin_access_identity.iam_arn]
    }
  }
}
