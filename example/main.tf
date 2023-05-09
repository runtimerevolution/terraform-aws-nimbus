module "example" {
    source = "../"

    enable_docker = true
    docker_image_name = "wordpress:latest"
    docker_container_name = "wordpress"
}