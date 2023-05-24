variable "solution_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "load_balancer_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "containers" {
  type = any
}

variable "ecs_launch_type" {
  type = string
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}