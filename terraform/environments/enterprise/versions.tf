terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.40.0, < 5.0.0"
    }
  }
}

# No provider block is included in this local-only scaffold.
# Configure authentication and subscription selection only after approval.
