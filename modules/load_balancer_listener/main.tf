resource "aws_lb_target_group" "target_group" {
  name        = "${var.solution_name}-target-group-${var.port}"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.load_balancer_id
  port              = var.port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "static" {
  count = var.path_pattern != null ? 1 : 0

  listener_arn = aws_lb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }

  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
}
