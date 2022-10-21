resource "azurerm_web_application_firwall_policy" "waf_policy" {
  name                = "waf-policy-${var.resource_suffix}-${var.resource_instance}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  tags                = var.resource_tags

    custom_rules {
        name      = "rule1"
        priority  = 1
        rule_type = "MatchRule"
        match_conditions {
        match_variables {
            variable_name = "RemoteAddr"
        }
        operator = "IPMatch"
        match_values = ["", ""]
        }
    
    }
}


