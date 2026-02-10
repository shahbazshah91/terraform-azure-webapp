resource "random_password" "mysql_admin" {
  length           = 6
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_private_dns_zone" "sql_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_zone_link" {
  name                  = "mysqlVnetZone-${local.name_prefix}"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.sql_zone.name
  virtual_network_id    = module.network.vnet_id
}

resource "azurerm_mysql_flexible_server" "main" {
  name                   = "mysql-${local.name_prefix}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = "sawebapp"
  administrator_password = random_password.mysql_admin
  backup_retention_days  = 2
  sku_name               = "B_Standard_B1ms"
  version = "8.0.21"
  public_network_access= "Enabled"

  storage {
    size_gb = "20"
    auto_grow_enabled = false
    io_scaling_enabled = true
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.sql_zone_link]

}

resource "azurerm_private_endpoint" "private_endpoint_mysql" {
  name                = "private-endpoint-mysql-${local.name_prefix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.network.subnet_ids[module.network.private_subnet_key]

  private_service_connection {
    name                           = "mysql-private-service-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.main.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_zone.id]
  }
}