variable "location" {
  description = "The Azure region to deploy resources"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "example-resources"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  default     = "example-log-analytics"
}

variable "metric_alert_name" {
  description = "The name of the metric alert"
  default     = "example-metric-alert"
}

variable "action_group_name" {
  description = "The name of the action group"
  default     = "example-actiongroup"
}

variable "email_address" {
  description = "The email address to send alerts to"
  default     = "example@example.com"
}
