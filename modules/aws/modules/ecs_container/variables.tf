variable "solution_name" {
  type    = string
  default = "default"
}

variable "vpc_id" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "lb_id" {
  type = string
}

variable "lb_security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "container_cpu" {
  type = number
}

variable "container_memory" {
  type = number
}
