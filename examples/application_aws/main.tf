locals {
  provider_region = "eu-north-1"
  containers = [
    {
      name  = "nginx-hello-world"
      image = "nginxdemos/hello:latest"
      #   "image"          = "nginx:latest"
      cpu            = 256
      memory         = 512
      port           = 80
      path_pattern   = "/app/*"
      instance_count = 2
    },
    {
      name           = "hello-world"
      image          = "registry.gitlab.com/architect-io/artifacts/nodejs-hello-world:latest"
      cpu            = 256
      memory         = 512
      port           = 3000
      instance_count = 2
    }
  ]
  databases = [
    {
      engine              = "postgres"
      password            = "password"
      skip_final_snapshot = true
    },
    {
      engine              = "mysql"
      password            = "password"
      skip_final_snapshot = true
    }
  ]
}

module "terraform_aws" {
  source = "../.."

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
  enable_static_website  = true
  enable_ecs             = true
  enable_secrets_manager = true
}
