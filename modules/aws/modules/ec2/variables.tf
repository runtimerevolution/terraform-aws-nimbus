variable "solution_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
  description = "The size of the EC2 instance to launch."
}

variable "security_group_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "capacity" {
  type = number
}

variable "capacity_min" {
  type = number
}

variable "capacity_max" {
  type = number
}

variable "ec2_health_check_grace_period" {
  type = number
  description = "Time (in seconds) after instance in the EC2 instance auto scaling group comes into service before checking health."
}

variable "ec2_health_check_type" {
  type = string
  description = "Controls how health checking in the EC2 instance auto scaling group is done."
}
