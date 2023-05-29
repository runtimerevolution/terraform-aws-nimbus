# -----------------------------------------------------------------------------
# Create Route53 hosted zone
# -----------------------------------------------------------------------------
resource "aws_route53_zone" "zone" {
  name = var.domain
}

# -----------------------------------------------------------------------------
# Create ACM certificates for the solution domain and subdomains
# -----------------------------------------------------------------------------
resource "aws_acm_certificate" "certificate" {
  domain_name = var.domain

  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain}"]

  lifecycle {
    create_before_destroy = true
  }
}

# -----------------------------------------------------------------------------
# Add ACM certificates to Route53
# -----------------------------------------------------------------------------
resource "aws_route53_record" "certificate" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.zone.zone_id
}

# -----------------------------------------------------------------------------
# Ensure the ACM certificate is valid
# -----------------------------------------------------------------------------
resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
}