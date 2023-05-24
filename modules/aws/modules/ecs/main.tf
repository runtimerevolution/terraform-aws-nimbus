resource "aws_ecs_cluster" "cluster" {
  name = "${var.solution_name}-cluster"
}

module "ec2" {
  count = var.ecs_launch_type == "EC2" ? 1 : 0

  source = "../ec2"

  solution_name     = var.solution_name
  cluster_name      = aws_ecs_cluster.cluster.name
  instance_type     = "t3.medium"
  security_group_id = var.load_balancer_security_group_id
  subnets_ids       = var.subnets_ids

  capacity     = 2
  capacity_min = 1
  capacity_max = 4
}

module "ecs_container" {
  for_each = var.containers

  source = "../ecs_container"

  solution_name     = var.solution_name
  vpc_id            = var.vpc_id
  cluster_id        = aws_ecs_cluster.cluster.id
  load_balancer_id  = var.load_balancer_id
  security_group_id = var.security_group_id
  subnet_ids        = var.subnets_ids
  launch_type       = var.ecs_launch_type

  container_name   = each.key
  instance_count   = each.value.instance_count
  container_image  = each.value.container_image
  container_cpu    = each.value.container_cpu
  container_memory = each.value.container_memory
  container_port   = each.value.container_port
}
