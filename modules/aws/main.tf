module "route53" {
  count = var.enable_custom_domain ? 1 : 0

  source = "./modules/route53"

  providers = {
    aws = aws.virginia
  }

  domain = var.domain
}

module "static_website" {
  source = "./modules/cloudfront"

  solution_name                  = var.solution_name
  enable_custom_domain           = var.enable_custom_domain
  domain                         = var.domain
  cloudfront_default_root_object = var.cloudfront_default_root_object
  cloudfront_origin_id           = var.cloudfront_origin_id
  cloudfront_price_class         = var.cloudfront_price_class
  acm_certificate_arn            = var.enable_custom_domain ? module.route53[0].acm_certificate_arn : null
  route53_zone_id                = var.enable_custom_domain ? module.route53[0].zone_id : null
}

module "network" {
  source = "./modules/network"

  solution_name         = var.solution_name
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnets_count  = var.public_subnets_count
  private_subnets_count = var.private_subnets_count
  from_port             = var.from_port
  to_port               = var.to_port
}

module "load_balancer" {
  source = "./modules/load_balancer"

  solution_name        = var.solution_name
  vpc_id               = module.network.vpc_id
  security_group_id    = module.network.security_group_id
  subnets_ids          = module.network.public_subnets_ids
  enable_custom_domain = var.enable_custom_domain
  domain               = var.domain
  route53_zone_id      = var.enable_custom_domain ? module.route53[0].zone_id : null
}

module "ecs" {
  count = length(keys(var.containers)) > 0 ? 1 : 0

  source = "./modules/ecs"

  solution_name                 = var.solution_name
  vpc_id                        = module.network.vpc_id
  load_balancer_id              = module.load_balancer.load_balancer_id
  security_group_id             = module.network.security_group_id
  subnets_ids                   = module.network.private_subnets_ids
  containers                    = var.containers
  ecs_launch_type               = var.ecs_launch_type
  ec2_instance_type             = var.ec2_instance_type
  ec2_health_check_grace_period = var.ec2_health_check_grace_period
  ec2_health_check_type         = var.ec2_health_check_type
}
