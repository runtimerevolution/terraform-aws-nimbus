locals {
  static_website_origin = var.storage_account_web_host != null ? {
    name                = "sa"
    host_name           = var.storage_account_web_host
    forwarding_protocol = "HttpsOnly"
    patterns_to_match   = ["/*"]
  } : null

  application_gateway_origin = var.application_gateway_public_ip_address != null ? {
    name                = "ag"
    host_name           = var.application_gateway_public_ip_address
    forwarding_protocol = "HttpOnly"
    patterns_to_match   = var.cdn_application_patterns_to_match
  } : null

  origins = [local.static_website_origin, local.application_gateway_origin]
}

resource "azurerm_cdn_frontdoor_profile" "frontdoor" {
  name                = "${var.solution_name}-frontdoor"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "${var.solution_name}-frontdoor-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}


module "route" {
  for_each = { for o in local.origins : o.name => o if o != null }

  source = "../azure_cdn_route"

  solution_name             = var.solution_name
  origin_name               = each.value.name
  cdn_frontdoor_profile_id  = azurerm_cdn_frontdoor_profile.frontdoor.id
  origin_host_name          = each.value.host_name
  cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.endpoint.id
  route_forwarding_protocol = each.value.forwarding_protocol
  route_patterns_to_match   = each.value.patterns_to_match
}
