output "resource_group_name" {
  description = "Resource group created for the platform."
  value       = azurerm_resource_group.platform.name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID."
  value       = azurerm_log_analytics_workspace.platform.id
}

output "key_vault_name" {
  description = "Key Vault name."
  value       = azurerm_key_vault.platform.name
}

output "sql_server_name" {
  description = "Azure SQL server name."
  value       = azurerm_mssql_server.database.name
}

output "sql_database_name" {
  description = "Azure SQL database name."
  value       = azurerm_mssql_database.platform.name
}

output "redis_name" {
  description = "Redis cache name."
  value       = azurerm_redis_cache.platform.name
}

output "service_bus_namespace" {
  description = "Service Bus namespace name."
  value       = azurerm_servicebus_namespace.platform.name
}

output "apim_name" {
  description = "API Management instance name."
  value       = azurerm_api_management.platform.name
}

output "container_app_environment_name" {
  description = "Container Apps environment name."
  value       = azurerm_container_app_environment.platform.name
}
