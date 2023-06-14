variable "solution_name" {
  type        = string
  description = "Name of the solution"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to create the resources."
}

variable "cluster_id" {
  type        = string
  description = "ECS Cluster ID in which to create the services in"
}

variable "load_balancer_id" {
  type        = string
  description = "Load balancer ID to assign to the ECS container listener"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to assign to the ECS container security group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to launch the EC2 instances in."
}

variable "launch_type" {
  type        = string
  description = "Launch type on which to run the ECS services."

  validation {
    condition     = contains(["FARGATE", "EC2"], var.launch_type)
    error_message = "Invalid value. Expected 'FARGATE' or 'EC2'."
  }
}

variable "instance_count" {
  type        = number
  description = "Number of instances of the task definition to place and keep running."
}

variable "name" {
  type        = string
  description = "Name of the container to associate with the load balancer."
}

variable "image" {
  type        = string
  description = "The image used to start a container. "
}

variable "port" {
  type        = number
  description = "Port on the container to associate with the load balancer."
}

variable "cpu" {
  type        = number
  description = "Number of cpu units used by the task."
}

variable "memory" {
  type        = number
  description = "Amount (in MiB) of memory used by the task."
}
