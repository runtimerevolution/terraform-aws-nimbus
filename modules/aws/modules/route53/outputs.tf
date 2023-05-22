output "zone_id" {
  value = aws_route53_zone.zone.id
}

output "acm_certificate_arn" {
  value = aws_acm_certificate_validation.certificate_validation.certificate_arn
}
