resource "aws_ecs_cluster" "cluster" {
  name = "${var.solution_name}-cluster"
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
}
