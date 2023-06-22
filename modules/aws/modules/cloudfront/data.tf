data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.static_website_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}
