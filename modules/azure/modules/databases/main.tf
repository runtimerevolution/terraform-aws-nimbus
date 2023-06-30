resource "azurerm_mssql_server" "server" {
  name                         = "${var.solution_name}-db-server"
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  administrator_login          = "kyoto-admin"
  administrator_login_password = "p4ssw0rd!"
  version                      = "12.0"
}

resource "azurerm_mssql_database" "test" {
  name      = "${var.solution_name}-db"
  server_id = azurerm_mssql_server.server.id

  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = 1
  sku_name    = "Basic"
}
