resource "azurerm_api_management_api" "this" {
  name                = var.name
  display_name        = var.display_name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name

  revision              = var.revision
  path                  = var.path
  protocols             = var.protocols
  service_url           = var.service_url
  subscription_required = var.subscription_required

  import {
    content_format = "openapi+json"
    content_value  = var.openapi_spec_content
  }

  lifecycle {
    precondition {
      condition     = can(regex("^[1-9][0-9]*$", var.revision))
      error_message = "Revision must be a positive integer represented as a string."
    }
  }
}
