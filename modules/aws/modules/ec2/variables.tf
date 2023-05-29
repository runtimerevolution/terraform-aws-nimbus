variable "solution_name" {
  type = string
}

variable "cluster_name" {
  type = string
  description = "Name of the ECS cluster where the EC2 instances will be launched."
}

variable "instance_type" {
  type = string
  description = "The size of the EC2 instance to launch."
}

variable "security_group_id" {
  type = string
  description = "Security group ID to assign to the AWS autoscaling group"
}

variable "subnets_ids" {
  type = list(string)
  description = "List of subnet IDs to launch the EC2 instances in."
}

variable "capacity" {
  type = number
  description = "The number of Amazon EC2 instances that should be running in the group."
}

variable "capacity_min" {
  type = number
  description = "Minimum size of the Auto Scaling Group."
}

variable "capacity_max" {
  type = number
  description = "Maximum size of the Auto Scaling Group"
}

variable "ec2_health_check_grace_period" {
  type = number
  description = "Time (in seconds) after instance in the EC2 instance auto scaling group comes into service before checking health."
}

variable "ec2_health_check_type" {
  type = string
  description = "Controls how health checking in the EC2 instance auto scaling group is done."
}
