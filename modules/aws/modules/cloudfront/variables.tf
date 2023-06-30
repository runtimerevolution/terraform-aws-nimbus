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

variable "static_website_root_object" {
  type        = string
  description = "Object CloudFront must return to return when an end user requests the root URL."
}

variable "custom_origin_http_port" {
  type        = number
  description = "The HTTP port the custom origin listens on."
}

variable "custom_origin_https_port" {
  type        = number
  description = "The HTTPS port the custom origin listens on."
}

variable "custom_origin_protocol_policy" {
  type        = string
  description = "The origin protocol policy to apply to your origin."

  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.custom_origin_protocol_policy)
    error_message = "Invalid value. Expected 'http-only', 'https-only' or 'match-viewer'."
  }
}

variable "custom_origin_ssl_protocols" {
  type        = list(string)
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS."
}

variable "path_patterns" {
  type        = list(string)
  description = "Path patterns that specifies which requests to apply a cache behavior."
}

variable "price_class" {
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
