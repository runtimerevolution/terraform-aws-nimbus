resource "aws_lb" "lb" {
  name            = "${var.solution_name}-lb"
  subnets         = var.subnets_ids
  security_groups = [var.security_group_id]
}