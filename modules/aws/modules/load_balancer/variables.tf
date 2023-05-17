variable "solution_name" {
  type    = string
}

variable "vpc_id" {
  type = string
}

variable "from_port" {
  type = number
}

variable "to_port" {
  type = number
}

variable "subnets_ids" {
  type = list(string)
}
