variable "resource_group_name" {
  description = "Existing resource group containing APIM."
  type        = string
}

variable "api_management_name" {
  description = "Existing API Management service name."
  type        = string
}

variable "product_id" {
  description = "Stable product identifier in APIM."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.product_id))
    error_message = "Product ID may contain letters, numbers, periods, underscores, and hyphens."
  }
}

variable "display_name" {
  description = "Human-readable product name."
  type        = string
}

variable "description" {
  description = "Purpose and intended consumers of the product."
  type        = string
  default     = null
  nullable    = true
}

variable "approval_required" {
  description = "Whether subscription requests require approval."
  type        = bool
  default     = true
}

variable "subscription_required" {
  description = "Whether consumers need a product subscription."
  type        = bool
  default     = true
}

variable "published" {
  description = "Whether the product is published and available to consumers."
  type        = bool
  default     = false
}

variable "subscriptions_limit" {
  description = "Optional maximum number of subscriptions per user."
  type        = number
  default     = null
  nullable    = true

  validation {
    condition     = var.subscriptions_limit == null ? true : var.subscriptions_limit >= 1 && floor(var.subscriptions_limit) == var.subscriptions_limit
    error_message = "subscriptions_limit must be a positive whole number or null."
  }
}

variable "terms" {
  description = "Optional product terms presented to consumers."
  type        = string
  default     = null
  nullable    = true
}

variable "api_names" {
  description = "API identifiers to associate with this product."
  type        = set(string)
  default     = []
}
