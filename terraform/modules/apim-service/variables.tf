variable "name" {
  description = "Globally unique Azure API Management service name."
  type        = string

  validation {
    condition     = length(var.name) <= 50 && can(regex("^[A-Za-z0-9]([A-Za-z0-9-]{0,48}[A-Za-z0-9])?$", var.name))
    error_message = "Use 1-50 letters, numbers or hyphens; the name must start and end with a letter or number."
  }
}

variable "location" {
  description = "Azure region for the APIM service."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "Location must not be empty."
  }
}

variable "resource_group_name" {
  description = "Name of the existing resource group. This module does not create it."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "Resource group name must not be empty."
  }
}

variable "publisher_name" {
  description = "Organization name displayed as the APIM publisher."
  type        = string

  validation {
    condition     = length(trimspace(var.publisher_name)) > 0
    error_message = "Publisher name must not be empty."
  }
}

variable "publisher_email" {
  description = "Contact email address for the APIM publisher."
  type        = string

  validation {
    condition     = can(regex("^[^ @]+@[^ @]+\\.[^ @]+$", var.publisher_email))
    error_message = "Provide a valid publisher email address."
  }
}

variable "sku_name" {
  description = "APIM SKU. This first module intentionally supports Standard v2 only."
  type        = string
  default     = "StandardV2_1"

  validation {
    condition     = var.sku_name == "StandardV2_1"
    error_message = "Only StandardV2_1 is supported by this initial module."
  }
}

variable "tags" {
  description = "Required organizational tags to apply to the APIM resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags :
      length(trimspace(key)) > 0 && length(trimspace(value)) > 0
    ])
    error_message = "Tag keys and values must not be empty."
  }
}
