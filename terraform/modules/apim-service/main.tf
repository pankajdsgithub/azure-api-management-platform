resource "azurerm_api_management" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name = var.sku_name

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.sku_name == "StandardV2_1"
      error_message = "This initial module supports Standard v2 only (StandardV2_1)."
    }
  }
}
