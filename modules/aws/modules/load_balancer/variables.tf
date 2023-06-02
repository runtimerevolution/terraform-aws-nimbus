variable "solution_name" {
  type    = string
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
