resource "aws_security_group" "security_group" {
  name   = "${var.solution_name}-lb-security-group"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.from_port
    to_port     = var.to_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "lb" {
  name            = "${var.solution_name}-lb"
  subnets         = var.subnets_ids
  security_groups = [aws_security_group.security_group.id]
}
