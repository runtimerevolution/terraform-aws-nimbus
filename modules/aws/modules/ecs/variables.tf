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
  type        = any
  description = "Details of docker containers to be deployed."
}

variable "ecs_launch_type" {
  type        = string
  description = "Launch type on which to run the ECS services."

  validation {
    condition     = contains(["FARGATE", "EC2"], var.ecs_launch_type)
    error_message = "Invalid value. Expected 'FARGATE' or 'EC2'."
  }
}

variable "ec2_instance_type" {
  type        = string
  description = "The size of the EC2 instance to launch."
}

variable "ec2_health_check_grace_period" {
  type        = number
  description = "Time (in seconds) after instance in the EC2 instance auto scaling group comes into service before checking health."
}

variable "ec2_health_check_type" {
  type        = string
  description = "Controls how health checking in the EC2 instance auto scaling group is done."
}
