resource "aws_ecs_cluster" "cluster" {
  name = "${var.solution_name}-cluster"
}

module "container" {
  for_each = var.containers

  source = "./modules/container"

  solution_name        = var.solution_name
  vpc_id               = aws_vpc.vpc.id
  cluster_id           = aws_ecs_cluster.cluster.id
  lb_id                = aws_lb.lb.id
  lb_security_group_id = aws_security_group.lb.id
  subnet_ids           = aws_subnet.private.*.id

  container_name   = each.key
  container_image  = each.value.container_image
  container_cpu    = each.value.container_cpu
  container_memory = each.value.container_memory
  container_port   = each.value.container_port
}