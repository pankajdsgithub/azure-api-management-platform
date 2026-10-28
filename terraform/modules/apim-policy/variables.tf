variable "resource_group_name" {
  description = "Existing resource group containing APIM."
  type        = string
}

variable "api_management_name" {
  description = "Existing API Management service name."
  type        = string
}

variable "api_name" {
  description = "Existing API identifier in APIM."
  type        = string
}

variable "xml_content" {
  description = "Complete APIM API policy XML content."
  type        = string

  validation {
    condition = (
      can(regex("<policies>", var.xml_content)) &&
      can(regex("</policies>", var.xml_content))
    )
    error_message = "Policy XML must contain opening and closing policies elements."
  }
}
