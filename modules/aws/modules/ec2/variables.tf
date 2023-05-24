variable "solution_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
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
