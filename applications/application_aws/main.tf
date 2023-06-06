locals {
  provider_region = "eu-north-1"
  containers = [
    {
      "name"           = "hello-world"
      "image"          = "registry.gitlab.com/architect-io/artifacts/nodejs-hello-world:latest"
      "cpu"            = 1024
      "memory"         = 2048
      "port"           = 3000
      "instance_count" = 2
    },
    {
      "name"           = "nginx"
      "image"          = "nginx:latest"
      "cpu"            = 1024
      "memory"         = 2048
      "port"           = 80
      "instance_count" = 2
    }
  ]
  databases = [
    {
      "engine"              = "postgres"
      "password"            = "password"
      "skip_final_snapshot" = true
    },
    {
      "engine"              = "mysql"
      "password"            = "password"
      "skip_final_snapshot" = true
    }
  ]
}

provider "aws" {
  region = local.provider_region
}

module "application_aws" {
  source = "../../modules/aws"

  solution_name          = "kyoto"
  enable_custom_domain   = true
  domain                 = "kyoto-tm.pt"
  provider_region        = local.provider_region
  from_port              = 80
  to_port                = 5432
  containers             = local.containers
  ecs_launch_type        = "EC2"
  ec2_instance_type      = "t3.medium"
  databases              = local.databases
  enable_bastion_host    = true
  enable_secrets_manager = true
}

# Deploy static website
resource "aws_s3_object" "website" {
  for_each = fileset("../../website/", "*")

  bucket       = module.application_aws.static_website_bucket.id
  key          = "website/${each.value}"
  source       = "../../website/${each.value}"
  content_type = "text/html"
  etag         = filemd5("../../website/${each.value}")
}
