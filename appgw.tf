resource "azurerm_public_ip" "appgw_ip" {
  name                = "appgw-ip-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "main" {
  name                = "appgatway-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku {
    name     = "Basic"
    tier     = "Basic"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration-${local.name_prefix}"
    subnet_id = module.network.subnet_ids[module.network.public_subnet_key]
  }

  frontend_port {
    name = local.app_gw.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.app_gw.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_ip.id
  }

  http_listener {
    name                           = local.app_gw.listener_name
    frontend_ip_configuration_name = local.app_gw.frontend_ip_configuration_name
    frontend_port_name             = local.app_gw.frontend_port_name
    protocol                       = "Http"
  }

  backend_address_pool {
    name = local.app_gw.backend_address_pool_name
    ip_addresses = [azurerm_network_interface.vm_nic.private_ip_address]
  }

  backend_http_settings {
    name                  = local.app_gw.http_setting_name
    cookie_based_affinity = "Disabled"
    #path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
    pick_host_name_from_backend_address = false  #override hostname setting from ui
    probe_name            = local.app_gw.probe_name
  }

  request_routing_rule {
    name                       = local.app_gw.request_routing_rule_name
    priority                   = 100
    rule_type                  = "Basic" #or PathBasedRouting
    http_listener_name         = local.app_gw.listener_name
    backend_address_pool_name  = local.app_gw.backend_address_pool_name
    backend_http_settings_name = local.app_gw.http_setting_name
  }

  probe {
    name = local.app_gw.probe_name
    host = "127.0.0.1"
    protocol = "Http"
    path = "/"
    interval = 30
    timeout = 30
    unhealthy_threshold = 3

    match {
        status_code = ["200-399"]
    }
  }

  tags = local.common_tags
}