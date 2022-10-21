locals {
  backend_address_pool_name = "appgw-backend-pool-${local.name_suffix}"
  frontend_port_name = "appgw-frontend-port-${local.name_suffix}"
  frontend_ip_name = "appgw-frontend-ip-${local.name_suffix}"
  http_setting_name = "appgw-http-setting-${local.name_suffix}"
  listerner_name = "appgw-listener-${local.name_suffix}"
  request_routing_rule_name = "appgw-request-routing-rule-${local.name_suffix}"
  redirect_config_name = "appgw-redirect-config-${local.name_suffix}"
}

resource "azurerm_application_gateway" "name" {
  name = "appgw-${var.resource_suffix}-${var.resource_instance}"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  zones = ["1", "2"]
  firewall_policy_id = module.wafpolicy.waf_policy_id
  force_firewall_policy_association = true
  sku {
    name = "WAF_Small"
    tier = "WAF_v2"
    capacity = 2
    }

    gateway_ip_configuration {
      name = "appgw-ip-config-${local.name_suffix}"
      subnet_id = module.spoke_net.subnet_id
    }

    frontend_port {
      name = local.frontend_port_name
      port = 80
    }

    frontend_ip_configuration {
      name = local.frontend_ip_name
      subnet_id = module.spoke_net.subnet_id
    }

    backend_address_pool {
      name = local.backend_address_pool_name
    }

    backend_http_settings {
      name = local.http_setting_name
      cookie_based_affinity = "Disabled"
      port = 80
      protocol = "Http"
      request_timeout = 1
    }

    http_listener {
      name = local.listerner_name
      frontend_ip_configuration_name = local.frontend_ip_name
      frontend_port_name = local.frontend_port_name
      protocol = "Http"
    }

    request_routing_rule {
      name = local.request_routing_rule_name
      rule_type = "Basic"
      http_listener_name = local.listerner_name
      backend_address_pool_name = local.backend_address_pool_name
      backend_http_settings_name = local.http_setting_name
    }

    waf_configuration {
        enabled = true
        firewall_mode = "Detection"
        rule_set_type = "OWASP"
        rule_set_version = "3.1"
        file_upload_limit_mb = 100
        max_request_body_size_kb = 128
        request_body_check = true
    }

 tags = var.resource_tags

}