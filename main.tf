

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-log-analytics"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostics"
  target_resource_id = azurerm_log_analytics_workspace.example.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "Administrative"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_metric_alert" "example" {
  name                = "example-metric-alert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_log_analytics_workspace.example.id]
  description         = "An example metric alert"
  severity            = 3
  enabled             = true
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "LogRate"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1000
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}

resource "azurerm_monitor_action_group" "example" {
  name                = "example-actiongroup"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "example"

  email_receiver {
    name          = "sendtoexample"
    email_address = "example@example.com"
  }
}
