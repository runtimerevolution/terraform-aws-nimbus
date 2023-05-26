variable "solution_name" {
  type = string
}

variable "enable_custom_domain" {
  type = bool
  description = "Specifies if DNS entries should be created for the solution resources."
}

variable "domain" {
  type = string
  description = "The base domain for the solution."
}

variable "cloudfront_default_root_object" {
  type = string
  description = "Object CloudFront must return to return when an end user requests the root URL."
}

variable "cloudfront_origin_id" {
  type = string
  description = "Origin id for the Cloudfront distribution."
}

variable "cloudfront_price_class" {
  type = string
  description = "Price class for the Cloudfront distribution."
}

variable "acm_certificate_arn" {
  type = string
}

variable "route53_zone_id" {
  type = string
}
