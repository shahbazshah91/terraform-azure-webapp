output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_ids" {
  value = { for k, v in azurerm_subnet.this : 
  k => v.id 
  }
}

output "nat_gateway_id" {
  value = var.enable_nat_gateway ? azurerm_nat_gateway.main[0].id : null
}

output "private_subnet_key" { 
  value = var.private_subnet_key
}

output "public_subnet_key"   { 
  value = var.public_subnet_key
}
