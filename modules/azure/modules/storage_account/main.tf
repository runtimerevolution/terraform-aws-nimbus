resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.solution_name}staticwebsite"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_kind             = var.storage_account_kind
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  dynamic "static_website" {
    for_each = [var.static_website_settings]

    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

}
