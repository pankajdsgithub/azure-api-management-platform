variable "location" {
  description = "Azure region for the platform resources."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "The resource group that will host the platform."
  type        = string
  default     = "rg-azure-platform-dev"
}

variable "prefix" {
  description = "Short prefix used for consistent naming of Azure resources."
  type        = string
  default     = "apimplat"
}

variable "tags" {
  description = "Tags applied to all platform resources."
  type        = map(string)
  default = {
    environment = "dev"
    owner       = "platform-team"
    workload    = "enterprise-api-platform"
    managed_by  = "terraform"
  }
}

variable "publisher_name" {
  description = "Publisher metadata for Azure API Management."
  type        = string
  default     = "Contoso Platform Team"
}

variable "publisher_email" {
  description = "Publisher contact email for Azure API Management."
  type        = string
  default     = "platform-team@contoso.com"
}

variable "sql_admin_login" {
  description = "Azure SQL administrator login."
  type        = string
  default     = "sqladminuser"
}

variable "sql_admin_password" {
  description = "Azure SQL administrator password. Keep this value in a secure secret manager."
  type        = string
  default     = "ChangeThisPassword123!"
  sensitive   = true
}

variable "customer_api_image" {
  description = "Container image for the customer API service."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "order_api_image" {
  description = "Container image for the order API service."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "worker_image" {
  description = "Container image for the worker service."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
