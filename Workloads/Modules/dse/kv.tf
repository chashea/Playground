provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
     resource_group {
      prevent_deletion_if_contains_resources = false // Set to True for Production
    }
  }
}

data "azurerm_client_config" "current" {}

// Create a resource group for the Keyvault
resource "azurerm_resource_group" "rg" {
  name     = "rg-kv-${var.location}-${var.environment}"
  location = var.location
  tags     = var.tags
}

// Create a Keyvault
resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.prefix}-${var.environment}-001"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  tags                        = var.tags
}

// Create a Keyvault Key
resource "azurerm_key_vault_key" "kv_key" {
  name         = "kv-key-${var.prefix}-${var.location}-${var.environment}-001"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048
  depends_on = [
    azurerm_key_vault_access_policy.kv_policy_user
  ]
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
  "wrapKey"]
}

// Create a Disk Encryption Set
resource "azurerm_disk_encryption_set" "dse" {
  name                = "dse-${var.prefix}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.kv_key.id
  encryption_type     = "EncryptionAtRestWithCustomerKey"
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}

// Create a Keyvault Access Policy for the Disk
resource "azurerm_key_vault_access_policy" "kv_policy_disk" {
  key_vault_id    = azurerm_key_vault.kv.id
  tenant_id       = azurerm_disk_encryption_set.dse.identity.0.tenant_id
  object_id       = azurerm_disk_encryption_set.dse.identity.0.principal_id
  key_permissions = ["Create", "Delete", "Get", "List", "Update", "Purge", "Recover", "Decrypt", "Sign", "WrapKey", "UnwrapKey", "Verify", "GetRotationPolicy"]
}

// Create a Keyvault Access Policy for the User
resource "azurerm_key_vault_access_policy" "kv_policy_user" {
  key_vault_id    = azurerm_key_vault.kv.id
  tenant_id       = data.azurerm_client_config.current.tenant_id
  object_id       = data.azurerm_client_config.current.object_id
  key_permissions = ["Get", "Create", "Delete", "Purge", "Recover", "Update", "List", "Decrypt", "Sign", "GetRotationPolicy"]
}

// Create a role assignment for the Keyvault
resource "azurerm_role_assignment" "kv_role" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.dse.identity.0.principal_id
}
