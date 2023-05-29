resource "aws_lb" "lb" {
  name            = "${var.solution_name}-lb"
  subnets         = var.subnets_ids
  security_groups = [var.security_group_id]
}

locals {
  domain = "lb.${var.domain}"
}

# -----------------------------------------------------------------------------
# Create a alias for the load balancer in Route53
# -----------------------------------------------------------------------------
resource "aws_route53_record" "alias" {
  count = var.enable_custom_domain ? 1 : 0

  zone_id = var.route53_zone_id
  name    = local.domain
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
