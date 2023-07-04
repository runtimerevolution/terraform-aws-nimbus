# Terraform AWS Nimbus

Terraform module which implements a three-tier architeture on AWS

![terraform_aws_nimbus](https://github.com/runtimerevolution/terraform-aws-nimbus/assets/119345743/1ac5933d-96e1-4173-8808-ba17bf10d7b0)

## Usage
```hcl
module "terraform_aws_nimbus" {
  source = "cld-vasconcelos/multicloud/aws"

  solution_name = "kyoto"

  provider_region = "eu-north-1"

  enable_static_website  = true
  enable_ecs             = true
  enable_bastion_host    = true
  enable_secrets_manager = true

  enable_custom_domain = true
  domain               = "kyoto-tm.pt"

  from_port = 80
  to_port   = 3306

  containers = [
    {
      name           = "nginx"
      "image"        = "nginx:latest"
      cpu            = 256
      memory         = 512
      port           = 80
      instance_count = 2
    }
  ]
  databases = [
    {
      engine = "postgres"
    }
  ]

  cloudfront_path_patterns = ["/app/*"]
}
```

## Input
**solution_name** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Name of the solution.

**bastion_ami_id** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: ID of the AMI to use when creating the bastion host.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: null

**bastion_instance_type** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The size of the EC2 instance to launch for hosting the bastion host.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "t3.micro"

**cloudfront_custom_origin_http_port** number\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The HTTP port the custom origin listens on.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: 80

**cloudfront_custom_origin_https_port** number\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The HTTPS port the custom origin listens on.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: 443

**cloudfront_custom_origin_protocol_policy** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The origin protocol policy to apply to your origin.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "http-only"

**cloudfront_custom_origin_ssl_protocols** list(string)\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: ["TLSv1.2"]

**cloudfront_path_patterns** list(string)\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Path patterns that specifies which requests to apply a cache behavior.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: []

**cloudfront_price_class** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Price class for the Cloudfront distribution.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "PriceClass_100"

**cloudfront_static_website_root_object** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Object CloudFront must return to return when an end user requests the root URL.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "index.html"

**containers** list(object({ name = string image = string cpu = number memory = number port = number path_pattern = optional(string) instance_count = number }))\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Container instances to be deployed.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: []

**databases** list( object({ identifier = optional(string) allocated_storage = optional(number) max_allocated_storage = optional(number) instance_class = optional(string) engine = string engine_version = optional(string) db_name = optional(string) username = optional(string) password = optional(string) port = optional(number) multi_az = optional(bool) backup_retention_period = optional(number) backup_window = optional(string) maintenance_window = optional(string) deletion_protection = optional(bool) enabled_cloudwatch_logs_exports = optional(list(string)) storage_encrypted = optional(bool) storage_type = optional(string) skip_final_snapshot = optional(bool) final_snapshot_identifier = optional(bool) publicly_accessible = optional(bool) }) )\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Databases instances to deploy. Explanation for each parameter can be found here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#argument-reference\
&nbsp;&nbsp;&nbsp;&nbsp;Default: []

**domain** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The base domain for the solution.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: null

**ec2_ami_id** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: ID of the AMI to use when creating EC2 instances. Documentation on how to check the available AMIs: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html\
&nbsp;&nbsp;&nbsp;&nbsp;Default: null

**ec2_health_check_grace_period** number\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Time (in seconds) after instance in the EC2 instance auto scaling group comes into service before checking health.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: 300

**ec2_health_check_type** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Controls how health checking in the EC2 instance auto scaling group is done.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "EC2"

**ec2_instance_type** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The size of the EC2 instance to launch.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "t3.micro"

**ecs_launch_type** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Launch type on which to run the ECS services.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "FARGATE"

**enable_bastion_host** bool\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Specifies if a bastion host to access private resources through SSH should be created.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: false

**enable_custom_domain** bool\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Specifies if DNS entries should be created for the solution resources.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: false

**enable_ecs** bool\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Enables/disables using ECS to host containers.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: false

**enable_secrets_manager** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Specifies if secrets manager should be used to store sensible data.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "false"

**enable_static_website** bool\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Enables/disables serving a static website hosted in a AWS S3 bucket.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: false

**environment** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Application environment type.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "Staging"

**from_port** number\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Start port for requests to the network.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: 80

**private_subnets_count** number\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The number of private subnets to create.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: 2

**provider_region** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: AWS region where the provider will operate.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "us-east-1"

**public_subnets_count** number\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The number of public subnets to create.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: 2

**to_port** number\
&nbsp;&nbsp;&nbsp;&nbsp;Description: End port for requests to the network.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: 80

**vpc_cidr_block** string\
&nbsp;&nbsp;&nbsp;&nbsp;Description: The IPv4 CIDR block for the VPC.\
&nbsp;&nbsp;&nbsp;&nbsp;Default: "10.32.0.0/16"

## Output
**cloudfront_endpoint**\
&nbsp;&nbsp;&nbsp;&nbsp;Description: Cloudfront distribution URL.

**databases_endpoints**\
&nbsp;&nbsp;&nbsp;&nbsp;
Description: Databases URLs.

**load_balancer_endpoint**\
&nbsp;&nbsp;&nbsp;&nbsp;
Description: Load balancer URL.

**static_website_bucket_endpoint**\
&nbsp;&nbsp;&nbsp;&nbsp;
Description: Static website S3 bucket URL.
