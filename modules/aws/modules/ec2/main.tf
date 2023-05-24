resource "aws_iam_role" "ecs_ec2_role" {
  name               = "${var.solution_name}-ec2"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_instance_profile" "ecs_ec2_role" {
  name = "${var.solution_name}-ec2"
  role = aws_iam_role.ecs_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_launch_configuration" "ecs_ec2_launch_config" {
  image_id             = data.aws_ami.amazon_linux.id
  iam_instance_profile = aws_iam_instance_profile.ecs_ec2_role.name
  security_groups      = [var.security_group_id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config"
  instance_type        = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_ec2_autoscaling_group" {
  name                 = "${var.solution_name}-ec2-autoscaling_group"
  vpc_zone_identifier  = var.subnets_ids
  launch_configuration = aws_launch_configuration.ecs_ec2_launch_config.name

  desired_capacity          = var.capacity
  min_size                  = var.capacity_min
  max_size                  = var.capacity_max
  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}
