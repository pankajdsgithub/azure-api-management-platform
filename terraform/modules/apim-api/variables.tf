variable "name" {
  description = "Stable API identifier in API Management."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.name))
    error_message = "API name may contain letters, numbers, periods, underscores, and hyphens."
  }
}

variable "display_name" {
  description = "Human-readable API display name."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group containing APIM."
  type        = string
}

variable "api_management_name" {
  description = "Name of the existing API Management service."
  type        = string
}

variable "path" {
  description = "Relative gateway path for this API; do not start with a slash."
  type        = string

  validation {
    condition     = length(var.path) > 0 && !startswith(var.path, "/")
    error_message = "API path must be non-empty and must not start with '/'."
  }
}

variable "openapi_spec_content" {
  description = "OpenAPI specification JSON content supplied by the calling module."
  type        = string

  validation {
    condition     = can(jsondecode(var.openapi_spec_content).openapi)
    error_message = "The supplied specification must be valid JSON containing an openapi field."
  }
}

variable "service_url" {
  description = "Optional backend base URL. Configure it when the backend endpoint is known and reachable."
  type        = string
  default     = null
  nullable    = true
}

variable "protocols" {
  description = "Client-facing gateway protocols."
  type        = list(string)
  default     = ["https"]

  validation {
    condition     = length(var.protocols) > 0 && alltrue([for p in var.protocols : contains(["http", "https"], p)])
    error_message = "Protocols must contain http, https, or both."
  }
}

variable "revision" {
  description = "Initial API revision."
  type        = string
  default     = "1"
}

variable "subscription_required" {
  description = "Whether APIM subscription keys are required. This is not a replacement for JWT authentication."
  type        = bool
  default     = true
}
