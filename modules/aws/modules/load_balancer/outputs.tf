output "lb_security_group_id" {
  value = aws_security_group.security_group.id
}

output "lb_id" {
  value = aws_lb.lb.id
}