output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_appgw_id" {
  value = azurerm_subnet.appgw.id
}

output "subnet_private_id" {
  value = azurerm_subnet.private.id
}

output "nat_gateway_id" {
  value = var.enable_nat_gateway ? azurerm_nat_gateway.main[0].id : null
}

