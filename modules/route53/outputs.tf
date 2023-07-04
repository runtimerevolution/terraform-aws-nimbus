output "zone_id" {
  value       = aws_route53_zone.zone.id
  description = "ID of Route53 zone."
}

output "acm_certificate_arn" {
  value       = aws_acm_certificate_validation.certificate_validation.certificate_arn
  description = "ARN of the certificate that is being validated."
}
