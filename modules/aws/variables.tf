variable "aws_provider_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_s3_bucket_name" {
  type    = string
  default = "thereisnowaythisbucketalreadyexists"
}

variable "aws_cloudfront_default_root_object" {
  type    = string
  default = "website/index.html"
}

variable "aws_cloudfront_origin_id" {
  type    = string
  default = "s3-origin"
}


variable "aws_cloudfront_price_class" {
  type    = string
  default = "PriceClass_100"
}
