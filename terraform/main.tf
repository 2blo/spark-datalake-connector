provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

variable "prefix" {
  default = "saspark"
}

resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-rg"
  location = "West Europe"
}