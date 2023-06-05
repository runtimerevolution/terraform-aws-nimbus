variable "solution_name" {
  type        = string
  description = "Name of the solution"
}

variable "ami_id" {
  type        = string
  description = "ID of the AMI to use when creating the bastion host."
}

variable "subnets_ids" {
  type        = list(string)
  description = "List of subnets IDs to launch the bastion host in."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to create the bastion host."
}
