resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_prefix}"
  location = var.location

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

module "network" {
  source = "./modules/network"

  name_prefix = local.name_prefix
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  vnet_address_space = var.vnet_address_space
  subnets = var.subnets

  private_subnet_key = var.private_subnet_key
  public_subnet_key = var.public_subnet_key

  enable_nat_gateway = true

  nsg_allowed_ports_private_subnet = [80,443]

  common_tags = local.common_tags

}

