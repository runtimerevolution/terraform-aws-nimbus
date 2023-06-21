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
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.solution_name}staticwebsite"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = var.static_website_index_document
    error_404_document = var.static_website_error_document
  }
}

# -----------------------------------------------------------------------------
# CDN
# -----------------------------------------------------------------------------
resource "azurerm_cdn_profile" "cdn_profile" {
  name                = "${var.solution_name}-cdn"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "endpoint" {
  name                = "${var.solution_name}-endpoint"
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  origin_host_header  = azurerm_storage_account.storage_account.primary_web_host

  origin {
    name      = "sa"
    host_name = azurerm_storage_account.storage_account.primary_web_host
  }
}
