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

variable "ec2_health_check_grace_period" {
  type = number
}

variable "ec2_health_check_type" {
  type = string
}

variable "ami_id" {
  type        = string
  description = "ID of the AMI to use when creating EC2 instances."
}
