module "docker" {
  count = var.enable_docker ? 1 : 0

  source = "./modules/docker"

  docker_image_name = var.docker_image_name
  docker_container_name = var.docker_container_name
}

module "aws" {
  count = var.enable_aws ? 1 : 0

  source = "./modules/aws"
}

