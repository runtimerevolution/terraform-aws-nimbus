module "terraform_multicloud_azure" {
  source = "../../modules/azure"

  # Project settings
  solution_name         = var.solution_name
  environment           = var.environment
  enable_static_website = var.enable_static_website
  enable_application    = var.enable_application

  # Cloud settings
  location                          = var.location
  static_website_settings           = var.static_website_settings
  cdn_application_patterns_to_match = var.cdn_application_patterns_to_match
  vnet_cidr                         = var.vnet_cidr
  containers                        = var.containers
}
