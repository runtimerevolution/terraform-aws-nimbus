locals {
  provider_region = "eu-north-1"
}

provider "aws" {
  region = local.provider_region
}

module "application_aws" {
  source = "../../modules/aws"

  # Provider
  solution_name   = "kyoto"
  provider_region = local.provider_region
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
