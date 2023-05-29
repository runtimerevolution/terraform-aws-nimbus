locals {
  provider_region = "eu-north-1"
  containers = {
    "hello-world" : {
      container_image  = "registry.gitlab.com/architect-io/artifacts/nodejs-hello-world:latest"
      container_cpu    = 1024
      container_memory = 2048
      container_port   = 3000
      instance_count   = 2
    },
    "nginx" : {
      container_image  = "nginx:latest"
      container_cpu    = 1024
      container_memory = 2048
      container_port   = 80
      instance_count   = 2
    }
  }
  databases = {
    "mysql-1" : {
      "allocated_storage"         = 5
      "backup_retention_period"   = 2
      "backup_window"             = "01:00-01:30"
      "maintenance_window"        = "sun:03:00-sun:03:30"
      "multi_az"                  = true
      "engine"                    = "mysql"
      "engine_version"            = "5.7"
      "instance_class"            = "db.t3.micro"
      "db_name"                   = "worker_db"
      "username"                  = "worker"
      "password"                  = "password"
      "port"                      = "3306"
      "skip_final_snapshot"       = true
      "final_snapshot_identifier" = "worker-final"
      "publicly_accessible"       = true
    }
  }
}

provider "aws" {
  region = local.provider_region
}

module "application_aws" {
  source = "../../modules/aws"

  solution_name        = "kyoto"
  enable_custom_domain = true
  domain               = "kyoto-tm.pt"
  provider_region      = local.provider_region
  from_port            = 80
  to_port              = 3000
  containers           = local.containers
  ecs_launch_type      = "EC2"
  ec2_instance_type    = "t3.medium"
  databases            = local.databases
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
