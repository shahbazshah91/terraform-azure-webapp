resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.common_tags
}

resource "azurerm_subnet" "appgw" {
  name                 = "snet-appgw-${var.name_prefix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.appgw_subnet_address_space
  
}

resource "azurerm_subnet" "private" {
  name                 = "snet-private-${var.name_prefix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_subnet_address_space
  default_outbound_access_enabled = false

}

resource "azurerm_subnet_nat_gateway_association" "private" {
  subnet_id      = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

resource "azurerm_network_security_group" "nsg_private_subnet" {
  name                = "nsg-private-snet-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "port-80-allow"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes      = var.appgw_subnet_address_space
    destination_address_prefixes = var.private_subnet_address_space
  }
  security_rule {
    name                       = "port-443-allow"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes      = var.appgw_subnet_address_space
    destination_address_prefixes = var.private_subnet_address_space
  }

  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.nsg_private_subnet.id
}
