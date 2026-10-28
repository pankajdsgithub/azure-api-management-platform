output "id" {
  description = "Resource ID of the API Management API."
  value       = azurerm_api_management_api.this.id
}

output "name" {
  description = "API identifier."
  value       = azurerm_api_management_api.this.name
}

output "path" {
  description = "Gateway path configured for this API."
  value       = azurerm_api_management_api.this.path
}
