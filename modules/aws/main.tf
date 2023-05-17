module "static_website" {
  source = "./modules/cloudfront"

  solution_name                  = var.solution_name
  cloudfront_default_root_object = var.cloudfront_default_root_object
  cloudfront_origin_id           = var.cloudfront_origin_id
  cloudfront_price_class         = var.cloudfront_price_class
}
