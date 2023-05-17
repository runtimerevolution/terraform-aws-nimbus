module "static_website" {
  source = "./modules/cloudfront"

  solution_name                  = var.solution_name
  cloudfront_default_root_object = var.cloudfront_default_root_object
  cloudfront_origin_id           = var.cloudfront_origin_id
  cloudfront_price_class         = var.cloudfront_price_class
}

module "network" {
  source = "./modules/network"

  solution_name = var.solution_name
  vpc_cidr_block = var.vpc_cidr_block
}
