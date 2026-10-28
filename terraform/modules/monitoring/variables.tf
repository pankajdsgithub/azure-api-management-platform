variable "name" {
  description = "Name of the diagnostic setting."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "The diagnostic setting name must not be empty."
  }
}

variable "target_resource_id" {
  description = "Resource ID of the existing Azure API Management service."
  type        = string

  validation {
    condition     = startswith(lower(var.target_resource_id), "/subscriptions/")
    error_message = "Provide a valid Azure resource ID beginning with /subscriptions/."
  }
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the existing Log Analytics workspace."
  type        = string

  validation {
    condition     = startswith(lower(var.log_analytics_workspace_id), "/subscriptions/")
    error_message = "Provide a valid Log Analytics workspace resource ID."
  }
}

variable "log_categories" {
  description = "Supported diagnostic log categories to enable. Obtain valid values from the target resource."
  type        = set(string)
  default     = []
}

variable "metric_categories" {
  description = "Supported metric categories to enable. Obtain valid values from the target resource."
  type        = set(string)
  default     = []
}
