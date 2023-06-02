variable "solution_name" {
  type    = string
  default = "default"
}

variable "vpc_id" {
  type = string
}

variable "load_balancer_id" {
  type = string
}

variable "port" {
  type = number
}
