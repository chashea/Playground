// Create outputs for Disk Encryption Set

output "dse_id" {
  value = data.azurerm_disk_encryption_set.dse.id
}

