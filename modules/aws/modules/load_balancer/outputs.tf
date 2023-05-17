output "load_balancer_security_group_id" {
  value = aws_security_group.security_group.id
}

output "load_balancer_id" {
  value = aws_lb.lb.id
}