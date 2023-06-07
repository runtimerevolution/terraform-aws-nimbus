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

variable "public_dns" {
  type        = string
  description = "DNS domain name of the application origin"
}

variable "cloudfront_default_root_object" {
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
