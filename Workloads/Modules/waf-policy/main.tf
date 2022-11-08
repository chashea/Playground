resource "azurerm_dns_zone" "example" {
  name                = "sub-domain.domain.com"
  resource_group_name = var.resource_group_name
}
resource "azurerm_cdn_frontdoor_profile" "fdprofile" {
  name                = "testprofile"
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor"
  tags                = var.resource_tags

}

resource "azurerm_cdn_frontdoor_custom_domain" "fddomain" {
  name = "fdsheadomaincom"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id
  dns_zone_id = azurerm_dns_zone.example.id
  host_name = "sheadomain.com"

  tls {
    certificate_type = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  name                = "wafpolicytest"
  resource_group_name = var.resource_group_name
  tags                = var.resource_tags
  enabled             = true
  mode                = "Prevention"
  sku_name            = azurerm_cdn_frontdoor_profile.fdprofile.sku_name
  
}


resource "azurerm_cdn_frontdoor_security_policy" "security_policy" {
  name = "securitypolicytest"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fdprofile.id

  security_policies {
    firewall {      
    cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id
    association {
    domain{
        cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.fddomain.id
       }
       patterns_to_match = [ "/*" ]
     }
   }
 }
}



