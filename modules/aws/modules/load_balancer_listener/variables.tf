variable "solution_name" {
  type        = string
  description = "Name of the solution"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to create the target group."
}

variable "load_balancer_id" {
  type        = string
  description = "Load balancer ID to assign to the listener"
}

variable "port" {
  type        = number
  description = "Port on which the load balancer is listening."
}
