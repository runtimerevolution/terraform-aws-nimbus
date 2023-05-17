resource "aws_ecs_cluster" "cluster" {
  name = "${var.solution_name}-cluster"
}

module "container" {
  for_each = var.containers

  source = "./modules/container"

  solution_name        = var.solution_name
  vpc_id               = aws_vpc.vpc.id
  cluster_id           = aws_ecs_cluster.cluster.id
  lb_id                = module.load_balancer.lb_id
  lb_security_group_id = module.load_balancer.lb_security_group_id
  subnet_ids           = aws_subnet.private.*.id

  container_name   = each.key
  container_image  = each.value.container_image
  container_cpu    = each.value.container_cpu
  container_memory = each.value.container_memory
  container_port   = each.value.container_port
}