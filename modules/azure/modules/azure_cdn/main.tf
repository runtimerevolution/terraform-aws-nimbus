resource "azurerm_cdn_profile" "cdn_profile" {
  name                = "${var.solution_name}-cdn"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "endpoint" {
  name                = "${var.solution_name}-endpoint"
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  origin_host_header  = var.storage_account_web_host

  origin {
    name      = "sa"
    host_name = var.storage_account_web_host
  }

  delivery_rule {
    name  = "EnforceHTTPS"
    order = "1"

    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }
}
