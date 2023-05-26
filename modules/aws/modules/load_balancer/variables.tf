variable "solution_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "enable_custom_domain" {
  type = bool
  description = "Specifies if DNS entries should be created for the load balancer."
}

variable "domain" {
  type = string
  description = "The base domain for the solution."
}

variable "route53_zone_id" {
  type = string
}
