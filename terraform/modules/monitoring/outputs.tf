output "diagnostic_setting_id" {
  description = "ID of the Azure Monitor diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "target_resource_id" {
  description = "Resource ID receiving the diagnostic setting."
  value       = var.target_resource_id
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the configured Log Analytics workspace."
  value       = var.log_analytics_workspace_id
}
