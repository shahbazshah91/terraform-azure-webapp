resource "azurerm_resource_group" "webapp_resource_group" {
  name     = "sa-webapp-resource-group"
  location = "Switzerland North"
}

resource "azurerm_bastion_host" "main" {
  name                = "bastion-${local.name_prefix}"
  location            = azurerm_resource_group.webapp_resource_group.location
  resource_group_name = azurerm_resource_group.webapp_resource_group.name
  sku = "Developer"
  virtual_network_id = module.network.vnet_id

  tags = local.common_tags

}

