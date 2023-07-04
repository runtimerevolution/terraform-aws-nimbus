output "load_balancer_id" {
  value       = aws_lb.lb.id
  description = "Load balancer ID."
}

output "load_balancer_dns_name" {
  value       = aws_lb.lb.dns_name
  description = "Load balancer URL."
}
