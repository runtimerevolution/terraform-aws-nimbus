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
}

variable "domain" {
  type = string
}

variable "route53_zone_id" {
  type = string
}
