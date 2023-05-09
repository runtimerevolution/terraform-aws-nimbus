module "example_docker" {
    source = "../../modules/docker"

    docker_image_name = "wordpress:latest"
    docker_container_name = "wordpress"
}