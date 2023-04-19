
// Create a Resource Group for Azure Firewall
resource "azurerm_resource_group" "rg_fw" {
  name     = local.fw_rg_name
  location = var.location
  tags     = var.tags
}

// Create a Public IP for Azure Firewall
resource "azurerm_public_ip" "pip_fw" {
  name                = local.fw_pip_name
  resource_group_name = local.fw_rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = azurerm_resource_group.rg_fw.tags
  depends_on = [
    azurerm_resource_group.rg_fw,
  ]
}

// Create the Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = local.fw_name
  location            = var.location
  resource_group_name = local.fw_rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_fw.id
    public_ip_address_id = azurerm_public_ip.pip_fw.id
  }
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  tags               = azurerm_resource_group.rg_fw.tags
  depends_on = [
    azurerm_resource_group.rg_fw,
    azurerm_subnet.subnet_fw,
    azurerm_public_ip.pip_fw,
    azurerm_firewall_policy.fw_policy
  ]
}