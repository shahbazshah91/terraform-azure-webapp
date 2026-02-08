resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = "Switzerland North"

  tags = local.common_tags
}

resource "azurerm_bastion_host" "main" {
  name                = "bastion-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku = "Developer"
  virtual_network_id = module.network.vnet_id

  tags = local.common_tags

}

