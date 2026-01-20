output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.this : 
  k => s.id 
  }
}

output "nat_gateway_id" {
  value = var.enable_nat_gateway ? azurerm_nat_gateway.main[0].id : null
}

