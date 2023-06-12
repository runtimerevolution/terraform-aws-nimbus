# -----------------------------------------------------------------------------
# Setup Route53 as the DNS for the solution
# -----------------------------------------------------------------------------
module "route53" {
  count = var.enable_custom_domain ? 1 : 0

  source = "./modules/route53"

  providers = {
    aws = aws.virginia
  }

  domain = var.domain
}

# -----------------------------------------------------------------------------
# Static website
# -----------------------------------------------------------------------------
module "static_website_bucket" {
  count = var.enable_static_website ? 1 : 0

  source = "./modules/s3_bucket"

  bucket_name        = "${var.solution_name}-static-website"
  bucket_acl         = "private"
  bucket_policy_json = data.aws_iam_policy_document.static_website_bucket.json
}

# -----------------------------------------------------------------------------
# Basic network infrastructure deployment
# -----------------------------------------------------------------------------
module "network" {
  source = "./modules/network"

  solution_name         = var.solution_name
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnets_count  = var.public_subnets_count
  private_subnets_count = var.private_subnets_count
  from_port             = var.from_port
  to_port               = var.to_port
}

# -----------------------------------------------------------------------------
# Setup a load balancer
# -----------------------------------------------------------------------------
module "load_balancer" {
  count = var.enable_ecs ? 1 : 0

  source = "./modules/load_balancer"

  solution_name        = var.solution_name
  security_group_id    = module.network.security_group_id
  subnets_ids          = module.network.public_subnets_ids
  enable_custom_domain = var.enable_custom_domain
  domain               = var.domain
  route53_zone_id      = var.enable_custom_domain ? module.route53[0].zone_id : null
}

# -----------------------------------------------------------------------------
# ECS cluster and services
# -----------------------------------------------------------------------------
module "ecs" {
  count = var.enable_ecs ? 1 : 0

  source = "./modules/ecs"

  solution_name                 = var.solution_name
  vpc_id                        = module.network.vpc_id
  load_balancer_id              = module.load_balancer[0].load_balancer_id
  security_group_id             = module.network.security_group_id
  subnets_ids                   = module.network.private_subnets_ids
  containers                    = var.containers
  ecs_launch_type               = var.ecs_launch_type
  ec2_instance_type             = var.ec2_instance_type
  ec2_health_check_grace_period = var.ec2_health_check_grace_period
  ec2_health_check_type         = var.ec2_health_check_type
  ami_id                        = var.ec2_ami_id
}

# -----------------------------------------------------------------------------
# Cloudfront
# -----------------------------------------------------------------------------
module "cloudfront" {
  source = "./modules/cloudfront"

  solution_name                         = var.solution_name
  enable_custom_domain                  = var.enable_custom_domain
  domain                                = var.domain
  static_website_url                    = var.enable_static_website ? module.static_website_bucket[0].bucket_regional_domain_name : null
  load_balancer_url                     = var.enable_ecs ? module.load_balancer[0].load_balancer_dns_name : null
  cloudfront_static_website_root_object = var.cloudfront_static_website_root_object
  path_patterns                         = compact([for c in var.containers : lookup(c, "path_pattern", null)])
  cloudfront_price_class                = var.cloudfront_price_class
  acm_certificate_arn                   = var.enable_custom_domain ? module.route53[0].acm_certificate_arn : null
  route53_zone_id                       = var.enable_custom_domain ? module.route53[0].zone_id : null
}

# -----------------------------------------------------------------------------
# Databases
# -----------------------------------------------------------------------------
module "databases" {
  count = length(var.databases) > 0 ? 1 : 0

  source = "./modules/databases"

  solution_name          = var.solution_name
  environment            = var.environment
  subnets_ids            = module.network.private_subnets_ids
  security_group_id      = module.network.security_group_id
  databases              = var.databases
  enable_secrets_manager = var.enable_secrets_manager
}

module "bastion_host" {
  count = var.enable_bastion_host ? 1 : 0

  source = "./modules/bastion_host"

  solution_name          = var.solution_name
  environment            = var.environment
  ami_id                 = var.bastion_ami_id
  instance_type          = var.bastion_instance_type
  subnets_ids            = module.network.public_subnets_ids
  vpc_id                 = module.network.vpc_id
  enable_secrets_manager = var.enable_secrets_manager
}
