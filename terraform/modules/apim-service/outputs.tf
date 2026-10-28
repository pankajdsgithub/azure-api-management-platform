output "id" {
  description = "Resource ID of the APIM service."
  value       = azurerm_api_management.this.id
}

output "name" {
  description = "Name of the APIM service."
  value       = azurerm_api_management.this.name
}

output "gateway_url" {
  description = "Default gateway URL. This output does not imply private-only access."
  value       = azurerm_api_management.this.gateway_url
}

output "developer_portal_url" {
  description = "Default developer portal URL."
  value       = azurerm_api_management.this.developer_portal_url
}

output "identity_principal_id" {
  description = "Principal ID of the system-assigned managed identity."
  value       = azurerm_api_management.this.identity[0].principal_id
}
