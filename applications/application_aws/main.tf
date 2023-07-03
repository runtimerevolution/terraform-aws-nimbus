locals {
  provider_region = "eu-north-1"
  containers = 
}

module "application_aws" {
  source = "../../modules/aws"

  

  
  from_port                = 80
  to_port                  = 5432
  containers               = local.containers

  databases                = local.databases
  enable_bastion_host      = true
  
  enable_secrets_manager   = true

}
