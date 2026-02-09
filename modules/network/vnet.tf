resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.common_tags
}

resource "azurerm_subnet" "this" {
  for_each             = var.subnets

  name                 = "snet-${each.value.name}-${var.name_prefix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.cidrs
  default_outbound_access_enabled = each.value.outbound_access_allow
}


resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = {
    for k,v in var.subnets :
    k => v if v.attach_nat
  }

  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.main[0].id
}

resource "azurerm_network_security_group" "nsg_private_subnet" {
  name                = "nsg-private-snet-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = toset(var.nsg_allowed_ports_private_subnet)

    content {
      name = "allow-port-${security_rule.value}"
      priority = 100 + (index(var.nsg_allowed_ports_private_subnet, security_rule.value) * 100)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range = tostring(security_rule.value)
      source_address_prefixes      = var.subnets[var.public_subnet_key].cidrs
      destination_address_prefixes = var.subnets[var.private_subnet_key].cidrs
    }
  }

  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.this[var.private_subnet_key].id
  network_security_group_id = azurerm_network_security_group.nsg_private_subnet.id
}
