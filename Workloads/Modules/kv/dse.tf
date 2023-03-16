// Create a Disk Encryption Set
resource "azurerm_disk_encryption_set" "dse" {
  name                = "dse-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  key_vault_key_id    = var.key_vault_key_id
  encryption_type     = "EncryptionAtRestWithCustomerKey"
  tags                = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      var.user_assigned_identity_id
    ]
  }
}