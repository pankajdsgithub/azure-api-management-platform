output "id" {
  description = "Resource ID of the APIM product."
  value       = azurerm_api_management_product.this.id
}

output "product_id" {
  description = "Stable product identifier."
  value       = azurerm_api_management_product.this.product_id
}

output "associated_api_names" {
  description = "API identifiers associated with this product."
  value       = sort(tolist(var.api_names))
}
