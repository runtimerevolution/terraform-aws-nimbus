resource "aws_ecs_cluster" "cluster" {
  name = "${var.solution_name}-cluster"
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = data.aws_ami.ecs_ami.id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [var.load_balancer_security_group_id]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config"
    instance_type        = "t3.medium"
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
    name                      = "asg"
    vpc_zone_identifier       = var.subnets_ids
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 10
    health_check_grace_period = 300
    health_check_type         = "EC2"
}

module "ecs_container" {
  for_each = var.containers

  source = "../ecs_container"

  solution_name                   = var.solution_name
  vpc_id                          = var.vpc_id
  cluster_id                      = aws_ecs_cluster.cluster.id
  load_balancer_id                = var.load_balancer_id
  load_balancer_security_group_id = var.load_balancer_security_group_id
  subnet_ids                      = var.subnets_ids

  container_name   = each.key
  container_image  = each.value.container_image
  container_cpu    = each.value.container_cpu
  container_memory = each.value.container_memory
  container_port   = each.value.container_port

  depends_on = [ aws_launch_configuration.ecs_launch_config ]
}
