resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                     = "${var.solution_name}-origin-group-${var.origin_name}"
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
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

resource "azurerm_cdn_frontdoor_origin" "origin" {
  name                          = "${var.solution_name}-origin-${var.origin_name}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id

  enabled                        = true
  host_name                      = var.origin_host_name
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.origin_host_name
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "${var.solution_name}-route-${var.origin_name}"
  cdn_frontdoor_endpoint_id     = var.cdn_frontdoor_endpoint_id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = var.route_patterns_to_match
  forwarding_protocol    = var.route_forwarding_protocol
  link_to_default_domain = true
  https_redirect_enabled = true
}

