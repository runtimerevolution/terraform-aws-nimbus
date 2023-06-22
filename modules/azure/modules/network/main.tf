resource "azurerm_virtual_network" "vnet" {
  name                = "${var.solution_name}-vnet"
  address_space       = var.vnet_address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}
