module "terraform_multicloud_azure" {
  source = "../../modules/azure"

  # Project settings
  solution_name = var.solution_name
  environment   = var.environment

  # Cloud settings
  location = var.location
}
