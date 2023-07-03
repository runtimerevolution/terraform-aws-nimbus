provider "aws" {
  region = var.provider_region
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
