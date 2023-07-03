resource "aws_ecs_cluster" "cluster" {
  name = "${var.solution_name}-cluster"
}

locals {
  instance_count = sum([for container in var.containers : container["instance_count"]])
}

# -----------------------------------------------------------------------------
# If launch type is 'EC2', setup an AWS autoscaling group 
# -----------------------------------------------------------------------------
module "ec2" {
  count = var.ecs_launch_type == "EC2" ? 1 : 0

  source = "../ec2"

  solution_name                 = var.solution_name
  cluster_name                  = aws_ecs_cluster.cluster.name
  instance_type                 = var.ec2_instance_type
  ami_id                        = var.ami_id
  security_group_id             = var.security_group_id
  subnets_ids                   = var.subnets_ids
  capacity                      = local.instance_count
  capacity_min                  = length(var.containers)
  capacity_max                  = local.instance_count
  ec2_health_check_grace_period = var.ec2_health_check_grace_period
  ec2_health_check_type         = var.ec2_health_check_type
}

module "ecs_container" {
  for_each = { for c in var.containers : c.name => c }

  source = "../ecs_container"

  solution_name     = var.solution_name
  vpc_id            = var.vpc_id
  cluster_id        = aws_ecs_cluster.cluster.id
  load_balancer_id  = var.load_balancer_id
  security_group_id = var.security_group_id
  subnet_ids        = var.subnets_ids
  launch_type       = var.ecs_launch_type

  name           = each.value.name
  image          = each.value.image
  cpu            = each.value.cpu
  memory         = each.value.memory
  port           = each.value.port
  path_pattern   = lookup(each.value, "path_pattern", null)
  instance_count = each.value.instance_count
}
