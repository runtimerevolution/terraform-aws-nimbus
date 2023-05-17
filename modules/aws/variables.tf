variable "solution_name" {
  type    = string
}

variable "provider_region" {
  type    = string
  default = "us-east-1"
}

variable "cloudfront_default_root_object" {
  type    = string
  default = "website/index.html"
}

variable "cloudfront_origin_id" {
  type    = string
  default = "s3-origin"
}

variable "cloudfront_price_class" {
  type    = string
  default = "PriceClass_100"
}
