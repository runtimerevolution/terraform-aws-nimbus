module "lb_listener" {
  source = "../load_balancer_listener"

  solution_name = var.solution_name
  vpc_id = var.vpc_id
  port = var.container_port
  load_balancer_id = var.load_balancer_id
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.solution_name}-${var.container_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  container_definitions    = <<DEFINITION
[
  {
    "image": "${var.container_image}",
    "cpu": ${var.container_cpu},
    "memory": ${var.container_memory},
    "name": "${var.container_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.container_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_security_group" "group" {
  name   = "${var.solution_name}-${var.container_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [var.load_balancer_security_group_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.solution_name}-${var.container_name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = var.launch_type

  network_configuration {
    security_groups = [aws_security_group.group.id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = module.lb_listener.lb_target_group_id
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [module.lb_listener]
}
