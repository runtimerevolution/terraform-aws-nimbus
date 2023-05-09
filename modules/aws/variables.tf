variable "aws_provider_region" {
  type    = string
  default = "eu-north-1"
}

variable "aws_ami_name" {
  type = string
}

variable "aws_virtualization_type" {
  type = string
}

variable "aws_ami_owner" {
  type = string
}

variable "aws_resource_group_name" {
  type = string
}

variable "aws_resource_group_query" {
  type = string
}

variable "aws_instance_name" {
  type = string
}

variable "aws_instance_type" {
  type = string
}
