locals {
  backend_address_pool_name      = "${var.solution_name}-beap"
  frontend_ip_configuration_name = "${var.solution_name}-feip"
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

  dynamic "frontend_port" {
    for_each = var.container_apps

    content {
      name = "${var.solution_name}-${frontend_port.value.name}-feport"
      port = frontend_port.value.port
    }
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [var.container_app_environment_static_ip_address]
  }

  dynamic "backend_http_settings" {
    for_each = var.container_apps

    content {
      name                  = "${var.solution_name}-${backend_http_settings.value.name}-be-htst"
      cookie_based_affinity = "Disabled"
      path                  = "/"
      port                  = backend_http_settings.value.port
      protocol              = "Http"
      request_timeout       = 60
      host_name             = backend_http_settings.value.fqdn
      probe_name            = "${backend_http_settings.value.name}-probe"
    }
  }

  dynamic "probe" {
    for_each = var.container_apps

    content {
      host                = probe.value.fqdn
      name                = "${probe.value.name}-probe"
      protocol            = "Http"
      path                = "/"
      interval            = 30
      timeout             = 30
      unhealthy_threshold = 3

      match {
        status_code = ["200"]
      }
    }
  }

  dynamic "http_listener" {
    for_each = var.container_apps

    content {
      name                           = "${var.solution_name}-${http_listener.value.name}-httplstn"
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = "${var.solution_name}-${http_listener.value.name}-feport"
      protocol                       = "Http"
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.container_apps

    content {
      name                       = "${var.solution_name}-${request_routing_rule.value.name}-rqrt"
      rule_type                  = "Basic"
      http_listener_name         = "${var.solution_name}-${request_routing_rule.value.name}-httplstn"
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = "${var.solution_name}-${request_routing_rule.value.name}-be-htst"
    }
  }

}
