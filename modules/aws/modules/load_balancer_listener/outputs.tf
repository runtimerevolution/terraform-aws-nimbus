output "lb_target_group_id" {
  value = try(aws_lb_target_group.target_group.id, "")
}