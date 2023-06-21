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
  name                     = "${var.solution_name}sa"
  resource_group_name      = azurerm_resource_group.group.name
  location                 = azurerm_resource_group.group.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.solution_name}-static-website"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
