# S3 bucket
resource "aws_s3_bucket" "b" {
  bucket = "thereisnowaythisbucketalreadyexists"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "b_ownership_controls" {
  bucket = aws_s3_bucket.b.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.b_ownership_controls]

  bucket = aws_s3_bucket.b.id
  acl    = "private"
}