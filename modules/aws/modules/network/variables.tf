variable "solution_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets_count" {
  type = number
}

variable "private_subnets_count" {
  type = number
}

variable "from_port" {
  type = number
}

variable "to_port" {
  type = number
}
