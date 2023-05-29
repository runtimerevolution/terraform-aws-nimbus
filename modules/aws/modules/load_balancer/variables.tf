variable "solution_name" {
  type = string
}

variable "security_group_id" {
  type = string
  description = "Security group ID to assign to the load balancer"
}

variable "subnets_ids" {
  type = list(string)
  description = "List of subnet IDs to launch the EC2 instances in."
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
  description = "The Route53 hosted zone ID to contain the alias record for the load balancer."
}
