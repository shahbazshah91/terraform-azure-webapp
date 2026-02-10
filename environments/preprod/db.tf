resource "random_password" "mysql_admin" {
  length           = 6
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
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
  public_network_access= "Disabled"

  storage {
    size_gb = "20"
    auto_grow_enabled = false
    io_scaling_enabled = true
  }

}