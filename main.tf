module "application_aws" {
  source = "./modules/aws"

  solution_name          = var.solution_name
  enable_custom_domain   = var.enable_custom_domain
  domain                 = var.domain
  provider_region        = var.provider_region
  from_port              = var.from_port
  to_port                = var.to_port
  containers             = var.containers
  ecs_launch_type        = var.ecs_launch_type
  ec2_instance_type      = var.ec2_instance_type
  databases              = var.databases
  enable_bastion_host    = var.enable_bastion_host
  enable_static_website  = var.enable_static_website
  enable_ecs             = var.enable_ecs
  enable_secrets_manager = var.enable_secrets_manager
}
