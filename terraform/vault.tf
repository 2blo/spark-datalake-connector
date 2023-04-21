resource "local_file" "key_pem" {
  content  = "foo!"
  filename = "${path.module}/foo.bar"
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault" "this" {
  name                        = "thiskeyvault"
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  depends_on = [local_file.key_pem]

  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 0
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "privatekey" {
  name         = "private-key"
  value        = tls_private_key.this.private_key_pem
  key_vault_id = data.azurerm_key_vault.this.id
}