resource "azurerm_api_management_product" "this" {
  product_id          = var.product_id
  display_name        = var.display_name
  description         = var.description
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name

  approval_required     = var.approval_required
  subscription_required = var.subscription_required
  published             = var.published
  subscriptions_limit   = var.subscriptions_limit
  terms                 = var.terms
}

resource "azurerm_api_management_product_api" "this" {
  for_each = var.api_names

  product_id          = azurerm_api_management_product.this.product_id
  api_name            = each.value
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
}
