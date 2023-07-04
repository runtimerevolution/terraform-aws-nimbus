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
**solution_name** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Name of the solution.

**bastion_ami_id** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;ID of the AMI to use when creating the bastion host.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `null`

**bastion_instance_type** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The size of the EC2 instance to launch for hosting the bastion host. Information about the diferent instances types can be found [here](https://aws.amazon.com/ec2/instance-types/).<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"t3.micro"`

**cloudfront_custom_origin_http_port** `number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The HTTP port the custom origin listens on.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `80`

**cloudfront_custom_origin_https_port** `number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The HTTPS port the custom origin listens on.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `443`

**cloudfront_custom_origin_protocol_policy** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The origin protocol policy to apply to your origin.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"http-only"`

**cloudfront_custom_origin_ssl_protocols** `list(string)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `["TLSv1.2"]`

**cloudfront_path_patterns** `list(string)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Path patterns that specifies which requests to apply a cache behavior.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `[]`

**cloudfront_price_class** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Price class for the Cloudfront distribution.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"PriceClass_100"`

**cloudfront_static_website_root_object** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Object CloudFront must return to return when an end user requests the root URL.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"index.html"`

**containers** `list(object)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Container instances to be deployed.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `[]`

**databases** `list(object)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Databases instances to deploy. Explanation for each parameter can be found [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#argument-reference).<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `[]`

**domain** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The base domain for the solution.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `null`

**ec2_ami_id** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;ID of the AMI to use when creating EC2 instances. Documentation on how to check the available AMIs can be found [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html). <br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `null`

**ec2_health_check_grace_period** `number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Time (in seconds) after instance in the EC2 instance auto scaling group comes into service before checking health.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `300`

**ec2_health_check_type** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Controls how health checking in the EC2 instance auto scaling group is done.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"EC2"`

**ec2_instance_type** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The size of the EC2 instance to launch. Information about the diferent instances types can be found [here](https://aws.amazon.com/ec2/instance-types/).<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"t3.micro"`

**ecs_launch_type** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Launch type on which to run the ECS services.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"FARGATE"`

**enable_bastion_host** `bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Specifies if a bastion host to access private resources through SSH should be created.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `false`

**enable_custom_domain** `bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Specifies if DNS entries should be created for the solution resources.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `false`

**enable_ecs** `bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Enables/disables using ECS to host containers.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `false`

**enable_secrets_manager** `bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Specifies if secrets manager should be used to store sensible data.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `false`

**enable_static_website** `bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Enables/disables serving a static website hosted in a AWS S3 bucket.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `false`

**environment** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Application environment type.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"Staging"`

**from_port** `number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Start port for requests to the network.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `80`

**private_subnets_count** `number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The number of private subnets to create.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `2`

**provider_region** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;AWS region where the provider will operate.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"us-east-1"`

**public_subnets_count** `number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The number of public subnets to create.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `2`

**to_port** `number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;End port for requests to the network.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `80`

**vpc_cidr_block** `string`<br>
&nbsp;&nbsp;&nbsp;&nbsp;The IPv4 CIDR block for the VPC.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Default: `"10.32.0.0/16"`

## Output
**cloudfront_endpoint**<br>
&nbsp;&nbsp;&nbsp;&nbsp;Cloudfront distribution URL.

**databases_endpoints**<br>
&nbsp;&nbsp;&nbsp;&nbsp;
Databases URLs.

**load_balancer_endpoint**<br>
&nbsp;&nbsp;&nbsp;&nbsp;
Load balancer URL.

**static_website_bucket_endpoint**<br>
&nbsp;&nbsp;&nbsp;&nbsp;
Static website S3 bucket URL.
