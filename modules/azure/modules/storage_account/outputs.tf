output "storage_account_web_host" {
  value       = azurerm_storage_account.storage_account.primary_web_host
  description = "The hostname with port if applicable for web storage in the primary location."
}
