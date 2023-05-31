variable "solution_name" {
  type = string
}

variable "provider_region" {
  type    = string
  default = "us-east-1"
}

variable "cloudfront_default_root_object" {
  type    = string
  default = "website/index.html"
}

variable "cloudfront_origin_id" {
  type    = string
  default = "s3-origin"
}

variable "cloudfront_price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.32.0.0/16"
}

variable "public_subnets_count" {
  type    = number
  default = 2
}

variable "private_subnets_count" {
  type    = number
  default = 2
}

variable "from_port" {
  type    = number
  default = 80
}

variable "to_port" {
  type    = number
  default = 80
}

variable "containers" {
  type    = any
  default = {}
}

variable "ecs_launch_type" {
  type    = string
  default = "FARGATE"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_health_check_grace_period" {
  type    = number
  default = 300
}

variable "ec2_health_check_type" {
  type    = string
  default = "EC2"
}

variable "ami" {
  type = object({
    name        = string
    most_recent = bool
    owners      = list(string)
  })
}
