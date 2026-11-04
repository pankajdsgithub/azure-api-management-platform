# Products control API publication and consumer subscriptions.
# They do not create a network boundary between internal and external traffic.

module "public_consumer_product" {
  count      = var.external_api_enabled ? 1 : 0
  depends_on = [terraform_data.configuration_guard]
  source     = "../../modules/apim-product"

  resource_group_name   = var.resource_group_name
  api_management_name   = module.apim_service.name
  product_id            = "public-consumer"
  display_name          = "Public Consumer APIs"
  description           = "Approved APIs for registered external consumers."
  approval_required     = true
  subscription_required = true
  published             = true

  api_names = toset([
    module.customer_api.name,
    module.orders_api.name
  ])
}

module "partner_product" {
  count      = var.partner_api_enabled ? 1 : 0
  depends_on = [terraform_data.configuration_guard]
  source     = "../../modules/apim-product"

  resource_group_name   = var.resource_group_name
  api_management_name   = module.apim_service.name
  product_id            = "partner-standard"
  display_name          = "Partner Standard APIs"
  description           = "Approved APIs for onboarded business partners."
  approval_required     = true
  subscription_required = true
  published             = true

  api_names = toset([
    module.customer_api.name,
    module.orders_api.name
  ])
}
