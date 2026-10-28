output "environment" {
  description = "Environment represented by this configuration."
  value       = var.environment
}

output "apim_service_name" {
  description = "Configured APIM service name."
  value       = module.apim_service.name
}

output "apim_service_id" {
  description = "APIM service resource ID."
  value       = module.apim_service.id
}

output "apim_gateway_url" {
  description = "APIM gateway URL; this does not imply private-only access."
  value       = module.apim_service.gateway_url
}

output "customer_api_id" {
  description = "Customer API resource ID."
  value       = module.customer_api.id
}

output "orders_api_id" {
  description = "Orders API resource ID."
  value       = module.orders_api.id
}

output "internal_product_id" {
  description = "Internal Standard product ID."
  value       = module.internal_product.id
}

output "diagnostic_setting_ids" {
  description = "Diagnostic setting IDs, empty when diagnostics are not configured."
  value       = [for diagnostic in module.apim_diagnostics : diagnostic.diagnostic_setting_id]
}
