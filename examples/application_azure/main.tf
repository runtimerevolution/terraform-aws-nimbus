module "terraform_multicloud_azure" {
  source = "../../modules/azure"

  # Project settings
  solution_name = var.solution_name
  environment   = var.environment

  # Cloud settings
  location                = var.location
  static_website_settings = var.static_website_settings
  vnet_address_space      = var.vnet_address_space
}
