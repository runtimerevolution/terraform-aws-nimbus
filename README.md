# Terraform AWS Nimbus

Terraform module which implements a three-tier architeture on AWS

![terraform_aws_nimbus](https://github.com/runtimerevolution/terraform-aws-nimbus/assets/119345743/1ac5933d-96e1-4173-8808-ba17bf10d7b0)

## Usage
```hcl
module "terraform_aws_nimbus" {
  source = "runtimerevolution/nimbus/aws"

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
### General
- **solution_name** `string`<br>
  - Name of the solution.

- **enable_secrets_manager** `bool`<br>
  - Specifies if secrets manager should be used to store sensible data.<br>
  - Default: `false`

- **environment** `string`<br>
  - Application environment type.<br>
  - Default: `"Staging"`

- **provider_region** `string`<br>
  - AWS region where the provider will operate.<br>
  - Default: `"us-east-1"`

### DNS

- **domain** `string`<br>
  - The base domain for the solution.<br>
  - Default: `null`

- **enable_custom_domain** `bool`<br>
  - Specifies if DNS entries should be created for the solution resources.<br>
  - Default: `false`

### Network

- **from_port** `number`<br>
  - Start port for requests to the network.<br>
  - Default: `80`

- **private_subnets_count** `number`<br>
  - The number of private subnets to create.<br>
  - Default: `2`

- **public_subnets_count** `number`<br>
  - The number of public subnets to create.<br>
  - Default: `2`

- **to_port** `number`<br>
  - End port for requests to the network.<br>
  - Default: `80`

- **vpc_cidr_block** `string`<br>
  - The IPv4 CIDR block for the VPC.<br>
  - Default: `"10.32.0.0/16"`

### Static website
- **enable_static_website** `bool`<br>
  - Enables/disables serving a static website hosted in a AWS S3 bucket.<br>
  - Default: `false`

### Application
- **containers** `list(object)`<br>
  - Container instances to be deployed.<br>
  - Default: `[]`

- **ec2_ami_id** `string`<br>
  - ID of the AMI to use when creating EC2 instances. Documentation on how to check the available AMIs can be found [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html). <br>
  - Default: `null`

- **ec2_health_check_grace_period** `number`<br>
  - Time (in seconds) after instance in the EC2 instance auto scaling group comes into service before checking health.<br>
  - Default: `300`

- **ec2_health_check_type** `string`<br>
  - Controls how health checking in the EC2 instance auto scaling group is done.<br>
  - Default: `"EC2"`

- **ec2_instance_type** `string`<br>
  - The size of the EC2 instance to launch. Information about the diferent instances types can be found [here](https://aws.amazon.com/ec2/instance-types/).<br>
  - Default: `"t3.micro"`

- **ecs_launch_type** `string`<br>
  - Launch type on which to run the ECS services.<br>
  - Default: `"FARGATE"`


### CDN
- **cloudfront_custom_origin_http_port** `number`<br>
  - The HTTP port the custom origin listens on.<br>
  - Default: `80`

- **cloudfront_custom_origin_https_port** `number`<br>
  - The HTTPS port the custom origin listens on.<br>
  - Default: `443`

- **cloudfront_custom_origin_protocol_policy** `string`<br>
  - The origin protocol policy to apply to your origin.<br>
  - Default: `"http-only"`

- **cloudfront_custom_origin_ssl_protocols** `list(string)`<br>
  - The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS.<br>
  - Default: `["TLSv1.2"]`

- **cloudfront_path_patterns** `list(string)`<br>
  - Path patterns that specifies which requests to apply a cache behavior.<br>
  - Default: `[]`

- **cloudfront_price_class** `string`<br>
  - Price class for the Cloudfront distribution.<br>
  - Default: `"PriceClass_100"`

- **cloudfront_static_website_root_object** `string`<br>
  - Object CloudFront must return to return when an end user requests the root URL.<br>
  - Default: `"index.html"`

- **enable_ecs** `bool`<br>
  - Enables/disables using ECS to host containers.<br>
  - Default: `false`

### Databases
- **databases** `list(object)`<br>
  - Databases instances to deploy. Explanation for each parameter can be found [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#argument-reference).<br>
  - Default: `[]`

### Bastion Host
- **bastion_ami_id** `string`<br>
  - ID of the AMI to use when creating the bastion host.<br>
  - Default: `null`

- **bastion_instance_type** `string`<br>
  - The size of the EC2 instance to launch for hosting the bastion host. Information about the diferent instances types can be found [here](https://aws.amazon.com/ec2/instance-types/).<br>
  - Default: `"t3.micro"`

- **enable_bastion_host** `bool`<br>
  - Specifies if a bastion host to access private resources through SSH should be created.<br>
  - Default: `false`
## Output
- **cloudfront_endpoint**<br>
  - Cloudfront distribution URL.

- **databases_endpoints**<br>
  - Databases URLs.

- **load_balancer_endpoint**<br>
  - Load balancer URL.

- **static_website_bucket_endpoint**<br>
  - Static website S3 bucket URL.
