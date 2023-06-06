variable "solution_name" {
  type        = string
  description = "Name of the solution"
}

variable "environment" {
  type        = string
  description = "Application environment type"

  validation {
    condition     = contains(["Staging", "Production"], var.environment)
    error_message = "Invalid value. Expected 'Staging' or 'Production'."
  }
}

variable "ami_id" {
  type        = string
  description = "ID of the AMI to use when creating the bastion host."
}

variable "instance_type" {
  type        = string
  description = "The size of the EC2 instance to launch for hosting the bastion host."
}

variable "subnets_ids" {
  type        = list(string)
  description = "List of subnets IDs to launch the bastion host in."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to create the bastion host."
}

variable "enable_secrets_manager" {
  type        = string
  description = "Specifies if secrets manager should be used to store sensible data."
  default     = "false"
}
