resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = "${var.solution_name}-frontdoor"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "${var.solution_name}-frontdoor-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group_1" {
  name                     = "${var.solution_name}-origin-group-ag"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin_1" {
  name                          = "${var.solution_name}-origin-ag"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group_1.id

  enabled                        = true
  host_name                      = var.application_gateway_public_ip_address
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.application_gateway_public_ip_address
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "route_1" {
  name                          = "${var.solution_name}-route-ag"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group_1.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin_1.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/app/*"]
  forwarding_protocol    = "HttpOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group_2" {
  name                     = "${var.solution_name}-origin-group-sa"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin_2" {
  name                          = "${var.solution_name}-origin-sa"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group_2.id

  enabled                        = true
  host_name                      = var.storage_account_web_host
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.storage_account_web_host
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "route_2" {
  name                          = "${var.solution_name}-route-sa"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group_2.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin_2.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}
