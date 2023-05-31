variable "solution_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami" {
  type = object({
    name        = string
    most_recent = bool
    owners      = list(string)
  })
}

variable "security_group_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "capacity" {
  type = number
}

variable "capacity_min" {
  type = number
}

variable "capacity_max" {
  type = number
}

variable "ec2_health_check_grace_period" {
  type = number
}

variable "ec2_health_check_type" {
  type = string
}
