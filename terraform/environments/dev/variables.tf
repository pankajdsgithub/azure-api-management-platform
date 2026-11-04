variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = var.environment == "dev"
    error_message = "This configuration is the dev environment."
  }
}

variable "location" {
  description = "Approved Azure region for the future APIM service."
  type        = string
  default     = "REPLACE_WITH_APPROVED_REGION"
}

variable "resource_group_name" {
  description = "Name of the existing resource group; this project does not create it."
  type        = string
  default     = "REPLACE_WITH_EXISTING_RESOURCE_GROUP"
}

variable "apim_name" {
  description = "Globally unique APIM service name."
  type        = string
  default     = "REPLACE_WITH_UNIQUE_APIM_NAME"
}

variable "publisher_name" {
  description = "APIM publisher organization."
  type        = string
  default     = "REPLACE_WITH_PUBLISHER_NAME"
}

variable "publisher_email" {
  description = "APIM publisher contact email."
  type        = string
  default     = "REPLACE_WITH_VALID_EMAIL"
}

variable "tags" {
  description = "Organizational tags."
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "azure-api-management-platform"
  }
}

variable "customer_backend_url" {
  description = "Approved reachable base URL for the Customer API backend."
  type        = string
  default     = null
  nullable    = true
}

variable "orders_backend_url" {
  description = "Approved reachable base URL for the Order API backend."
  type        = string
  default     = null
  nullable    = true
}

variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics workspace resource ID; leave null until selected."
  type        = string
  default     = null
  nullable    = true
}

variable "diagnostic_log_categories" {
  description = "Diagnostic log categories verified as supported by the target APIM resource."
  type        = set(string)
  default     = []
}

variable "diagnostic_metric_categories" {
  description = "Diagnostic metric categories verified as supported by the target APIM resource."
  type        = set(string)
  default     = []
}

variable "jwt_policy_enabled" {
  description = "Attach the JWT policy only after its tenant, audience, client IDs and authorization requirements are configured."
  type        = bool
  default     = false
}


variable "external_api_enabled" {
  description = "Opt in to publishing the approved APIs through a public-consumer APIM product. This does not configure network isolation."
  type        = bool
  default     = false
}

variable "partner_api_enabled" {
  description = "Opt in to publishing the approved APIs through a partner APIM product. This does not configure network isolation."
  type        = bool
  default     = false
}

variable "entra_tenant_id" {
  description = "Microsoft Entra tenant UUID used by the JWT validation policy."
  type        = string
  default     = null
  nullable    = true
}

variable "api_audience" {
  description = "Expected access-token audience for the APIs."
  type        = string
  default     = null
  nullable    = true
}

variable "allowed_client_application_ids" {
  description = "Approved Entra client application UUIDs allowed by the API JWT policy."
  type        = set(string)
  default     = []

  validation {
    condition = alltrue([
      for id in var.allowed_client_application_ids :
      can(regex(
        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$",
        id
      ))
    ])
    error_message = "Every allowed client application ID must be a UUID."
  }
}
