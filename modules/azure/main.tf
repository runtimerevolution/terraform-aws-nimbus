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

  solution_name                    = var.solution_name
  resource_group_name              = azurerm_resource_group.resource_group.name
  resource_group_location          = azurerm_resource_group.resource_group.location
  storage_account_kind             = "StorageV2"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  static_website_settings = {
    index_document     = "index.html"
    error_404_document = "error.html"
  }
}

# -----------------------------------------------------------------------------
# Virtual network and subnets
# -----------------------------------------------------------------------------
module "network" {
  source = "./modules/network"

  solution_name           = var.solution_name
  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  vnet_cidr               = var.vnet_cidr
}

# -----------------------------------------------------------------------------
# Container Apps
# -----------------------------------------------------------------------------
module "container_app_environment" {
  source = "./modules/container_app_environment"

  solution_name           = var.solution_name
  resource_group_name     = azurerm_resource_group.resource_group.name
  resource_group_location = azurerm_resource_group.resource_group.location
  private_subnet_id       = module.network.private_subnet_id
  containers              = var.containers
}

# -----------------------------------------------------------------------------
# Application Gateway
# -----------------------------------------------------------------------------
module "application_gateway" {
  source = "./modules/application_gateway"

  solution_name                               = var.solution_name
  resource_group_name                         = azurerm_resource_group.resource_group.name
  resource_group_location                     = azurerm_resource_group.resource_group.location
  public_subnet_id                            = module.network.public_subnet_id
  container_app_environment_static_ip_address = module.container_app_environment.container_app_environment_static_ip_address
  container_apps                              = module.container_app_environment.container_apps
}

# -----------------------------------------------------------------------------
# CDN
# -----------------------------------------------------------------------------
module "cdn" {
  source = "./modules/azure_cdn"

  solution_name                         = var.solution_name
  resource_group_name                   = azurerm_resource_group.resource_group.name
  resource_group_location               = azurerm_resource_group.resource_group.location
  storage_account_web_host              = module.static_website.storage_account_web_host
  application_gateway_public_ip_address = module.application_gateway.application_gateway_public_ip_address

  depends_on = [ module.application_gateway ]
}

