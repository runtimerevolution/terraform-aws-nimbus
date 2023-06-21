# -----------------------------------------------------------------------------
# Resource Group to contain the solution resources
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "resource_group" {
  name     = var.solution_name
  location = var.location
}

# -----------------------------------------------------------------------------
# Static website
# -----------------------------------------------------------------------------
module "static_website" {
  source = "./modules/storage_account"

  solution_name           = var.solution_name
  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  static_website = {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}

# -----------------------------------------------------------------------------
# CDN
# -----------------------------------------------------------------------------
module "cdn" {
  source = "./modules/azure_cdn"

  solution_name            = var.solution_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  resource_group_location  = azurerm_resource_group.resource_group.location
  storage_account_web_host = module.static_website.storage_account_web_host
}
