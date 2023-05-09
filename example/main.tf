module "example" {
    source = "../"

    enable_docker = true
    image_name = "wordpress:latest"
    container_name = "wordpress"
}