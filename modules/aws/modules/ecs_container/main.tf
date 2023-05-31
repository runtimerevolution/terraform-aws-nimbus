# -----------------------------------------------------------------------------
# Setup a load balancer listener for the ECS service
# -----------------------------------------------------------------------------
module "lb_listener" {
  source = "../load_balancer_listener"

  solution_name    = var.solution_name
  vpc_id           = var.vpc_id
  port             = var.port
  load_balancer_id = var.load_balancer_id
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.solution_name}-${var.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = <<DEFINITION
[
  {
    "image": "${var.image}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "name": "${var.name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.port},
        "hostPort": ${var.port}
      }
    ]
  }
]
DEFINITION
}

# -----------------------------------------------------------------------------
# Create a security group to assign to the ECS services
# -----------------------------------------------------------------------------
resource "aws_security_group" "group" {
  name   = "${var.solution_name}-${var.name}-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.port
    to_port         = var.port
    security_groups = [var.security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.solution_name}-${var.name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.instance_count
  launch_type     = var.launch_type

  network_configuration {
    security_groups = [aws_security_group.group.id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = module.lb_listener.lb_target_group_id
    container_name   = var.name
    container_port   = var.port
  }

  depends_on = [module.lb_listener]
}
