resource "aws_lb" "lb" {
  name            = "${var.solution_name}-lb"
  subnets         = var.subnets_ids
  security_groups = [var.security_group_id]
}

resource "aws_route53_record" "subdomain" {
  count = var.enable_custom_domain ? 1 : 0

  zone_id = var.route53_zone_id
  name    = "lb.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
