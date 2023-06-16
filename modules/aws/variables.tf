variable "solution_name" {
  type        = string
  description = "Name of the solution."
}

variable "enable_custom_domain" {
  type        = bool
  description = "Specifies if DNS entries should be created for the solution resources."
  default     = false
}

variable "domain" {
  type        = string
  description = "The base domain for the solution."
  default     = null
}

variable "provider_region" {
  type        = string
  description = "AWS region where the provider will operate."
  default     = "us-east-1"
}

variable "cloudfront_default_root_object" {
  type        = string
  description = "Object CloudFront must return to return when an end user requests the root URL."
  default     = "website/index.html"
}

variable "cloudfront_origin_id" {
  type        = string
  description = "Origin id for the Cloudfront distribution."
  default     = "s3-origin"
}

variable "cloudfront_price_class" {
  type        = string
  description = "Price class for the Cloudfront distribution."
  default     = "PriceClass_100"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VPC."
  default     = "10.32.0.0/16"
}

variable "public_subnets_count" {
  type        = number
  description = "The number of public subnets to create."
  default     = 2
}

variable "private_subnets_count" {
  type        = number
  description = "The number of private subnets to create."
  default     = 2
}

variable "from_port" {
  type        = number
  description = "Start port for requests to the network."
  default     = 80
}

variable "to_port" {
  type        = number
  description = "End port for requests to the network."
  default     = 80
}

variable "containers" {
  type = list(object({
    name           = string
    image          = string
    cpu            = number
    memory         = number
    port           = number
    instance_count = number
  }))
  description = "Container instances to be deployed."
  default     = []
}

variable "ecs_launch_type" {
  type        = string
  description = "Launch type on which to run the ECS services."
  default     = "FARGATE"

  validation {
    condition     = contains(["FARGATE", "EC2"], var.ecs_launch_type)
    error_message = "Invalid value. Expected 'FARGATE' or 'EC2'."
  }
}

variable "ec2_instance_type" {
  type        = string
  description = "The size of the EC2 instance to launch."
  default     = "t3.micro"
}

variable "ec2_health_check_grace_period" {
  type        = number
  description = "Time (in seconds) after instance in the EC2 instance auto scaling group comes into service before checking health."
  default     = 300
}

variable "ec2_health_check_type" {
  type        = string
  description = "Controls how health checking in the EC2 instance auto scaling group is done."
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "ELB"], var.ec2_health_check_type)
    error_message = "Invalid value. Expected 'EC2' or 'ELB'."
  }
}

variable "ami_id" {
  type        = string
  description = "ID of the AMI to use when creating EC2 instances. Documentation on how to check the available AMIs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html"
  default     = null
}

variable "databases" {
  type = list(
    object({
      identifier                      = optional(string)
      allocated_storage               = optional(number)
      max_allocated_storage           = optional(number)
      instance_class                  = optional(string)
      engine                          = string
      engine_version                  = optional(string)
      db_name                         = optional(string)
      username                        = optional(string)
      password                        = optional(string)
      port                            = optional(number)
      multi_az                        = optional(bool)
      backup_retention_period         = optional(number)
      backup_window                   = optional(string)
      maintenance_window              = optional(string)
      deletion_protection             = optional(bool)
      enabled_cloudwatch_logs_exports = optional(list(string))
      storage_encrypted               = optional(bool)
      storage_type                    = optional(string)
      skip_final_snapshot             = optional(bool)
      final_snapshot_identifier       = optional(bool)
      publicly_accessible             = optional(bool)
    })
  )
  description = "Databases instances to deploy. Explanation for each parameter can be found here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#argument-reference"
  default     = []
}
