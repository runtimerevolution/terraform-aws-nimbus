output "lb_target_group_id" {
  value       = aws_lb_target_group.target_group.id
  description = "Load balancer listener target group."
}
