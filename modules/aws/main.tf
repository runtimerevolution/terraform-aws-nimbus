module "static_website" {
  source = "./modules/cloudfront"

  solution_name                  = var.solution_name
  cloudfront_default_root_object = var.cloudfront_default_root_object
  cloudfront_origin_id           = var.cloudfront_origin_id
  cloudfront_price_class         = var.cloudfront_price_class
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

  solution_name     = var.solution_name
  vpc_id            = module.network.vpc_id
  security_group_id = module.network.security_group_id
  subnets_ids       = module.network.public_subnets_ids
}

module "ecs" {
  count = length(keys(var.containers)) > 0 ? 1 : 0

  source = "./modules/ecs"

  solution_name     = var.solution_name
  vpc_id            = module.network.vpc_id
  load_balancer_id  = module.load_balancer.load_balancer_id
  security_group_id = module.network.security_group_id
  subnets_ids       = module.network.private_subnets_ids
  containers        = var.containers
}
