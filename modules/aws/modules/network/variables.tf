variable "solution_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
  description = "The IPv4 CIDR block for the VPC."
}

variable "public_subnets_count" {
  type = number
  description = "The number of public subnets to create."
}

variable "private_subnets_count" {
  type = number
  description = "The number of private subnets to create."
}

variable "from_port" {
  type = number
  description = "Start port for requests to the network."
}

variable "to_port" {
  type = number
  description = "End port for requests to the network."
}
