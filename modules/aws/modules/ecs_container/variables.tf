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

variable "load_balancer_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "launch_type" {
  type = string
}

variable "instance_count" {
  type = number
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
