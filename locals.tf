locals {
    project = "webapp-php"
    
    common_tags = {
        project = local.project
        environment = var.environment
        managed_by = "terraform"
    }
    
    name_prefix = "${local.project}-${var.environment}"
}

#for appgateway
locals {
  backend_address_pool_name      = "${module.network.vnet_name}-beap"
  frontend_port_name             = "${module.network.vnet_name}-feport"
  frontend_ip_configuration_name = "${module.network.vnet_name}-feip"
  http_setting_name              = "${module.network.vnet_name}-be-htst"
  listener_name                  = "${module.network.vnet_name}-httplstn"
  request_routing_rule_name      = "${module.network.vnet_name}-rqrt"
  redirect_configuration_name    = "${module.network.vnet_name}-rdrcfg"
  probe_name                     = "${module.network.vnet_name}-probe"
}