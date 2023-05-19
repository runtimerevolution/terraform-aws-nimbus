resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_acm_certificate" "example" {
  domain_name       = var.domain
  
  validation_method = "DNS"
  subject_alternative_names = ["*.${var.domain}"]

  provider = aws.virginia

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  provider = aws.virginia
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

######

module "static_website" {
  source = "./modules/cloudfront"

  solution_name                  = var.solution_name
  domain                         = var.domain
  cloudfront_default_root_object = var.cloudfront_default_root_object
  cloudfront_origin_id           = var.cloudfront_origin_id
  cloudfront_price_class         = var.cloudfront_price_class
  acm_certificate_arn            = aws_acm_certificate_validation.example.certificate_arn
}

####

resource "aws_route53_record" "root-a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = module.static_website.cdn.domain_name
    zone_id                = module.static_website.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www-a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = module.static_website.cdn.domain_name
    zone_id                = module.static_website.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

#####

module "network" {
  source = "./modules/network"

  solution_name         = var.solution_name
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnets_count  = var.public_subnets_count
  private_subnets_count = var.private_subnets_count
}

module "load_balancer" {
  source = "./modules/load_balancer"

  solution_name = var.solution_name
  vpc_id        = module.network.vpc_id
  from_port     = var.load_balancer_from_port
  to_port       = var.load_balancer_to_port
  subnets_ids   = module.network.public_subnets_ids
}

module "ecs" {
  count = length(keys(var.containers)) > 0 ? 1 : 0

  source = "./modules/ecs"

  solution_name                   = var.solution_name
  vpc_id                          = module.network.vpc_id
  load_balancer_id                = module.load_balancer.load_balancer_id
  load_balancer_security_group_id = module.load_balancer.load_balancer_security_group_id
  subnets_ids                     = module.network.private_subnets_ids
  containers                      = var.containers
}
