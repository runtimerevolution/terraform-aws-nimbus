provider "aws" {
  region = "eu-north-1"
}

module "example_aws" {
  source = "../../modules/aws"

  # Provider
  aws_provider_region = "eu-north-1"

  # AMI
  aws_ami_name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  aws_virtualization_type = "hvm"
  aws_ami_owner = "099720109477"

  # Resource Group
  aws_resource_group_name  = "ExampleResourceGroup"
  aws_resource_group_query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::EC2::Instance"
  ],
  "TagFilters": [
    {
      "Key": "Name",
      "Values": ["ExampleAppServerInstance"]
    }
  ]
}
JSON

  # Instance
  aws_instance_type = "t3.micro"
  aws_instance_name = "ExampleAppServerInstance"
}

# Deploy static website
resource "aws_s3_object" "website" {
  for_each = fileset("../../website/", "*")

  bucket = module.example_aws.s3_static_website_bucket
  key    = "website/${each.value}"
  source = "../../website/${each.value}"
  content_type = "text/html"
  etag   = filemd5("../../website/${each.value}")
}