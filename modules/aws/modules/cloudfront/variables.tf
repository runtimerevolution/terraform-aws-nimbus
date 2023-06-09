variable "solution_name" {
  type        = string
  description = "Name of the solution."
}

variable "enable_custom_domain" {
  type        = bool
  description = "Specifies if DNS entries should be created for the solution resources."
}

variable "domain" {
  type        = string
  description = "The base domain for the solution."
}

variable "static_website_url" {
  type        = string
  description = "Public URL of the S3 bucket hosting the static website."
}

variable "load_balancer_url" {
  type        = string
  description = "Public URL of the load balancer."
}

variable "cloudfront_static_website_root_object" {
  type        = string
  description = "Object CloudFront must return to return when an end user requests the root URL."
}

variable "cloudfront_price_class" {
  type        = string
  description = "Price class for the Cloudfront distribution."
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the AWS Certificate Manager certificate to use with the distribution."
}

variable "route53_zone_id" {
  type        = string
  description = "The Route53 hosted zone ID to contain the alias record for the distribution."
}
