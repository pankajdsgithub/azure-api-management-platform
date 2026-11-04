locals {
  configuration_is_placeholder = (
    startswith(var.location, "REPLACE_") ||
    startswith(var.resource_group_name, "REPLACE_") ||
    startswith(var.apim_name, "REPLACE_") ||
    startswith(var.publisher_name, "REPLACE_") ||
    startswith(var.publisher_email, "REPLACE_")
  )
}

locals {
  jwt_policy_content = templatefile(
    "${path.root}/../../../policies/jwt-validation-policy.xml.tftpl",
    {
      tenant_id = coalesce(
        var.entra_tenant_id,
        "REPLACE_WITH_TENANT_ID"
      )
      api_audience = coalesce(
        var.api_audience,
        "REPLACE_WITH_API_APPLICATION_ID_URI"
      )
      allowed_client_application_ids_xml = join("", [
        for id in sort(tolist(var.allowed_client_application_ids)) :
        "               <application-id>${id}</application-id>\n"
      ])
    }
  )
}

resource "terraform_data" "configuration_guard" {
  input = "dev-configuration-guard"

  lifecycle {
    precondition {
      condition = (
        !local.configuration_is_placeholder &&
        (
          !var.jwt_policy_enabled ||
          (
            can(regex(
              "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$",
              coalesce(var.entra_tenant_id, "")
            )) &&
            length(trimspace(coalesce(var.api_audience, ""))) > 0 &&
            !startswith(trimspace(coalesce(var.api_audience, "")), "REPLACE_") &&
            length(var.allowed_client_application_ids) > 0
          )
        ) &&
        (
          !(var.external_api_enabled || var.partner_api_enabled) ||
          var.jwt_policy_enabled
        )
      )
      error_message = "Invalid dev configuration: replace all REPLACE_ placeholders; when JWT validation is enabled, supply a valid Entra tenant UUID, a non-empty API audience, and at least one approved client application UUID. External and partner products require JWT validation."
    }
  }
}

# APIM service: references an EXISTING Resource Group.
# This module does not create the Resource Group.
module "apim_service" {
  depends_on = [terraform_data.configuration_guard]
  source     = "../../modules/apim-service"

  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  tags                = var.tags
}

# OpenAPI definitions are read from local project files.
# Backend URLs remain null until an approved reachable URL is supplied.
module "customer_api" {
  depends_on = [terraform_data.configuration_guard]
  source     = "../../modules/apim-api"

  name                = "customer-api"
  display_name        = "Customer API"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim_service.name
  path                = "customers"
  openapi_spec_content = file(
    "${path.root}/../../../apis/customer/openapi.json"
  )
  service_url           = var.customer_backend_url
  protocols             = ["https"]
  revision              = "1"
  subscription_required = true
}

module "orders_api" {
  depends_on = [terraform_data.configuration_guard]
  source     = "../../modules/apim-api"

  name                = "orders-api"
  display_name        = "Orders API"
  resource_group_name = var.resource_group_name
  api_management_name = module.apim_service.name
  path                = "orders"
  openapi_spec_content = file(
    "${path.root}/../../../apis/orders/openapi.json"
  )
  service_url           = var.orders_backend_url
  protocols             = ["https"]
  revision              = "1"
  subscription_required = true
}

# Product remains unpublished by default.
# APIs are associated by their Terraform API names.
module "internal_product" {
  depends_on = [terraform_data.configuration_guard]
  source     = "../../modules/apim-product"

  resource_group_name   = var.resource_group_name
  api_management_name   = module.apim_service.name
  product_id            = "internal-standard"
  display_name          = "Internal Standard"
  description           = "Internal API product; publish only after review."
  approval_required     = true
  subscription_required = true
  published             = false
  api_names = toset([
    module.customer_api.name,
    module.orders_api.name
  ])
}

# JWT policy is opt-in. Enable only after its Entra ID settings
# and authorization requirements have been reviewed.
module "customer_jwt_policy" {
  depends_on = [terraform_data.configuration_guard]
  count      = var.jwt_policy_enabled ? 1 : 0
  source     = "../../modules/apim-policy"

  resource_group_name = var.resource_group_name
  api_management_name = module.apim_service.name
  api_name            = module.customer_api.name
  xml_content         = local.jwt_policy_content
}

module "orders_jwt_policy" {
  depends_on = [terraform_data.configuration_guard]
  count      = var.jwt_policy_enabled ? 1 : 0
  source     = "../../modules/apim-policy"

  resource_group_name = var.resource_group_name
  api_management_name = module.apim_service.name
  api_name            = module.orders_api.name
  xml_content         = local.jwt_policy_content
}

# Diagnostics are omitted until an existing workspace and at least
# one verified diagnostic category are supplied.
module "apim_diagnostics" {
  depends_on = [terraform_data.configuration_guard]
  count = var.log_analytics_workspace_id == null ? 0 : (
    length(var.diagnostic_log_categories) +
    length(var.diagnostic_metric_categories) > 0 ? 1 : 0
  )

  source = "../../modules/monitoring"

  name                       = "${var.apim_name}-diagnostics"
  target_resource_id         = module.apim_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log_categories             = var.diagnostic_log_categories
  metric_categories          = var.diagnostic_metric_categories
}

# Service-level policy: inherited by API policies through <base />.
resource "azurerm_api_management_policy" "global" {
  api_management_id = module.apim_service.id
  xml_content       = file("${path.root}/../../../policies/global-policy.xml")
}
