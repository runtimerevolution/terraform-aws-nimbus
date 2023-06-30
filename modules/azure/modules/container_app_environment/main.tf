
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.solution_name}-la"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                           = "${var.solution_name}-ca-env"
  location                       = var.resource_group_location
  resource_group_name            = var.resource_group_name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.main.id
  infrastructure_subnet_id       = var.private_subnet_id
  internal_load_balancer_enabled = true
}

resource "azurerm_container_app" "app" {
  for_each = { for c in var.containers : c.name => c }

  name                         = "${var.solution_name}-${each.value.name}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = each.value.name
      image  = each.value.image
      cpu    = each.value.cpu
      memory = each.value.memory
    }
    min_replicas = each.value.min_replicas
    max_replicas = each.value.max_replicas
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = each.value.port

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
