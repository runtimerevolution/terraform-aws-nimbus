# -----------------------------------------------------------------------------
# Resource Group to contain the solution resources
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "group" {
  name     = var.solution_name
  location = var.location
}

# -----------------------------------------------------------------------------
# Static website
# -----------------------------------------------------------------------------
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.solution_name}staticwebsite"
  resource_group_name      = azurerm_resource_group.group.name
  location                 = azurerm_resource_group.group.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = var.static_website_index_document
  }
}

# -----------------------------------------------------------------------------
# CDN
# -----------------------------------------------------------------------------
