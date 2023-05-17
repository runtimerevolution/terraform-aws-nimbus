resource "aws_ecs_cluster" "cluster" {
  name = "${var.solution_name}-cluster"
}

module "container-hello-world" {
  source = "./modules/container"

  solution_name        = var.solution_name
  vpc_id               = aws_vpc.vpc.id
  cluster_id           = aws_ecs_cluster.cluster.id
  lb_id                = aws_lb.lb.id
  lb_security_group_id = aws_security_group.lb.id
  subnet_ids           = aws_subnet.private.*.id

  container_name   = "hello-world"
  container_image  = "registry.gitlab.com/architect-io/artifacts/nodejs-hello-world:latest"
  container_cpu    = 1024
  container_memory = 2048
  container_port   = 3000
}

module "container-nginx" {
  source = "./modules/container"

  solution_name        = var.solution_name
  vpc_id               = aws_vpc.vpc.id
  cluster_id           = aws_ecs_cluster.cluster.id
  lb_id                = aws_lb.lb.id
  lb_security_group_id = aws_security_group.lb.id
  subnet_ids           = aws_subnet.private.*.id

  container_name   = "nginx"
  container_image  = "nginx:latest"
  container_cpu    = 1024
  container_memory = 2048
  container_port   = 80
}

# module "container-wordpress" {
#   source = "./modules/container"

#   solution_name        = var.solution_name
#   vpc_id               = aws_vpc.vpc.id
#   cluster_id           = aws_ecs_cluster.cluster.id
#   lb_target_group_id   = aws_lb_target_group.lb.id
#   lb_security_group_id = aws_security_group.lb.id
#   subnet_ids           = aws_subnet.private.*.id
#   security_group_id    = aws_security_group.task.id

#   container_name   = "wordpress"
#   container_image  = "wordpress:latest"
#   container_cpu    = 1024
#   container_memory = 2048
#   container_port   = 80

#   depends_on = [aws_lb_listener.lb]
# }
