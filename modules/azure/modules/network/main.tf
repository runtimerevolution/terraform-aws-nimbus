# -----------------------------------------------------------------------------
# Virtual network
# -----------------------------------------------------------------------------
resource "azurerm_network_watcher" "network_watcher" {
  name                = "${var.solution_name}-network-watcher"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.solution_name}-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# -----------------------------------------------------------------------------
# Subnets
# -----------------------------------------------------------------------------
resource "azurerm_subnet" "public" {
  name                 = "${var.solution_name}-public-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, 1)]
}

resource "azurerm_subnet" "private" {
  name                 = "${var.solution_name}-private-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 4, 2)]
}
