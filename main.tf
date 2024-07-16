

data "azurerm_resource_group" "example" {
  name = "existing"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacct-001"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "tfstate-001"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}


resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-log-analytics-001"
  location            = azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostics-001"
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
  name                = "example-metric-alert-001"
  resource_group_name = data.azurerm_resource_group.example.name
#   location            = data.azurerm_resource_group.example.location
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
  name                = "example-actiongroup-001"
  resource_group_name = data.azurerm_resource_group.example.name
  short_name          = "example"

  email_receiver {
    name          = "sendtoexample"
    email_address = "example@example.com"
  }
}
