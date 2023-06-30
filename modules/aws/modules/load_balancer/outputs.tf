output "load_balancer_id" {
  value = aws_lb.lb.id
}

output "load_balancer_dns_name" {
  value = aws_lb.lb.dns_name
}
