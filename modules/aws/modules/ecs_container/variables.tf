variable "solution_name" {
  type    = string
}

variable "vpc_id" {
  type = string
  description = "VPC in which to create the resources."
}

variable "cluster_id" {
  type = string
  description = "ECS Cluster in which to create the services in"
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
  description = "Launch type on which to run the ECS services."

  validation {
    condition     = contains(["FARGATE", "EC2"], var.ecs_launch_type)
    error_message = "Invalid value. Expected 'FARGATE' or 'EC2'."
  }
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
