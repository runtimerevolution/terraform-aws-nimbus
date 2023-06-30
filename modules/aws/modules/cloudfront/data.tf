data "aws_iam_policy_document" "logging_bucket" {
  statement {
    actions   = ["s3:*"]
    resources = ["${module.bucket_cloudfront.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}
