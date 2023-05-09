module "docker" {
  count = var.enable_docker ? 1 : 0

  source = "./modules/docker"

  image_name = var.image_name
  container_name = var.container_name
}