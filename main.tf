module "terraform_multicloud" {
  source = "./modules/aws"

  # Project settings
  solution_name = var.solution_name

  # Cloud settings
  environment                              = var.environment
  enable_custom_domain                     = var.enable_custom_domain
  domain                                   = var.domain
  provider_region                          = var.provider_region
  enable_static_website                    = var.enable_static_website
  enable_ecs                               = var.enable_ecs
  cloudfront_static_website_root_object    = var.cloudfront_static_website_root_object
  cloudfront_custom_origin_http_port       = var.cloudfront_custom_origin_http_port
  cloudfront_custom_origin_https_port      = var.cloudfront_custom_origin_https_port
  cloudfront_custom_origin_protocol_policy = var.cloudfront_custom_origin_protocol_policy
  cloudfront_custom_origin_ssl_protocols   = var.cloudfront_custom_origin_ssl_protocols
  cloudfront_path_patterns                 = var.cloudfront_path_patterns
  cloudfront_price_class                   = var.cloudfront_price_class
  vpc_cidr_block                           = var.vpc_cidr_block
  public_subnets_count                     = var.public_subnets_count
  private_subnets_count                    = var.private_subnets_count
  from_port                                = var.from_port
  to_port                                  = var.to_port
  containers                               = var.containers
  ecs_launch_type                          = var.ecs_launch_type
  ec2_instance_type                        = var.ec2_instance_type
  ec2_health_check_grace_period            = var.ec2_health_check_grace_period
  ec2_health_check_type                    = var.ec2_health_check_type
  ec2_ami_id                               = var.ec2_ami_id
  databases                                = var.databases
  enable_bastion_host                      = var.enable_bastion_host
  bastion_ami_id                           = var.bastion_ami_id
  bastion_instance_type                    = var.bastion_instance_type
  enable_secrets_manager                   = var.enable_secrets_manager
}
