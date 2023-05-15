locals {
  aws_provider_region = "eu-north-1"
}

provider "aws" {
  region = local.aws_provider_region
}

module "application_aws" {
  source = "../../modules/aws"

  solution_name = "kyoto"
  aws_provider_region = local.aws_provider_region
}

# Deploy static website
resource "aws_s3_object" "website" {
  for_each = fileset("../../website/", "*")

  bucket = module.application_aws.s3_static_website_bucket
  key    = "website/${each.value}"
  source = "../../website/${each.value}"
  content_type = "text/html"
  etag   = filemd5("../../website/${each.value}")
}