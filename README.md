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

## Output
