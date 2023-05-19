locals {
  provider_region = "eu-north-1"
  containers = {
    "hello-world" : {
      container_image  = "registry.gitlab.com/architect-io/artifacts/nodejs-hello-world:latest"
      container_cpu    = 1024
      container_memory = 2048
      container_port   = 3000
    },
    "nginx" : {
      container_image  = "nginx:latest"
      container_cpu    = 1024
      container_memory = 2048
      container_port   = 80
    }
  }
}

provider "aws" {
  region = local.provider_region
}

module "application_aws" {
  source = "../../modules/aws"

  solution_name = "kyoto"
  domain        = "kyoto-tm.pt"

  provider_region         = local.provider_region
  load_balancer_from_port = 80
  load_balancer_to_port   = 3000
  containers              = local.containers
}

# Deploy static website
resource "aws_s3_object" "website" {
  for_each = fileset("../../website/", "*")

  bucket       = module.application_aws.static_website_bucket.id
  key          = "website/${each.value}"
  source       = "../../website/${each.value}"
  content_type = "text/html"
  etag         = filemd5("../../website/${each.value}")
}
