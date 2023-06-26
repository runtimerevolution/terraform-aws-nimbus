locals {
  backend_address_pool_name      = "${var.solution_name}-beap"
  frontend_port_name             = "${var.solution_name}-feport"
  frontend_ip_configuration_name = "${var.solution_name}-feip"
  http_setting_name              = "${var.solution_name}-be-htst"
  listener_name                  = "${var.solution_name}-httplstn"
  request_routing_rule_name      = "${var.solution_name}-rqrt"
  redirect_configuration_name    = "${var.solution_name}-rdrcfg"
}

resource "azurerm_public_ip" "app_gateway" {
  name                = "${var.solution_name}-app-gateway-pip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "${var.solution_name}-app-gateway"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.public_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [var.container_app_environment_static_ip_address] #[azurerm_container_app_environment.main.static_ip_address]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    host_name             = var.container_app_fqdn #azurerm_container_app.main.latest_revision_fqdn
    probe_name            = "probe"
  }

  probe {
    host                = var.container_app_fqdn #azurerm_container_app.main.latest_revision_fqdn
    name                = "probe"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = ["200"]
    }
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}