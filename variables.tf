variable "solution_name" {
  type        = string
  description = "Name of the solution."
}

variable "environment" {
  type        = string
  description = "Application environment type."
  default     = "Staging"

  validation {
    condition     = contains(["Staging", "Production"], var.environment)
    error_message = "Invalid value. Expected 'Staging' or 'Production'."
  }
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

variable "enable_static_website" {
  type        = bool
  description = "Enables/disables serving a static website hosted in a AWS S3 bucket."
  default     = false
}

variable "enable_ecs" {
  type        = bool
  description = "Enables/disables using ECS to host containers."
  default     = false
}

variable "cloudfront_static_website_root_object" {
  type        = string
  description = "Object CloudFront must return to return when an end user requests the root URL."
  default     = "website/index.html"
}


variable "cloudfront_custom_origin_http_port" {
  type        = number
  description = "The HTTP port the custom origin listens on."
  default     = 80
}

variable "cloudfront_custom_origin_https_port" {
  type        = number
  description = "The HTTPS port the custom origin listens on."
  default     = 443
}

variable "cloudfront_custom_origin_protocol_policy" {
  type        = string
  description = "The origin protocol policy to apply to your origin."
  default     = "http-only"

  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.cloudfront_custom_origin_protocol_policy)
    error_message = "Invalid value. Expected 'http-only', 'https-only' or 'match-viewer'."
  }
}

variable "cloudfront_custom_origin_ssl_protocols" {
  type        = list(string)
  description = "The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS."
  default     = ["TLSv1.2"]
}

variable "cloudfront_path_patterns" {
  type        = list(string)
  description = "Path patterns that specifies which requests to apply a cache behavior."
  default     = []
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
    path_pattern   = optional(string)
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

variable "ec2_ami_id" {
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

variable "enable_bastion_host" {
  type        = bool
  description = "Specifies if a bastion host to access private resources through SSH should be created."
  default     = false
}

variable "bastion_ami_id" {
  type        = string
  description = "ID of the AMI to use when creating the bastion host."
  default     = null
}

variable "bastion_instance_type" {
  type        = string
  description = "The size of the EC2 instance to launch for hosting the bastion host."
  default     = "t3.micro"
}

variable "enable_secrets_manager" {
  type        = string
  description = "Specifies if secrets manager should be used to store sensible data."
  default     = "false"
}
