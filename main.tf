terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
}

provider "azurerm" {
  features{}
}


resource "azurerm_resource_group" "resource_groups" {
  for_each = var.resource_groups
  name     = each.value.name
  location = each.value.location
}


resource "azurerm_virtual_wan" "vwan" {
  name                = var.vwan.name
  resource_group_name = var.vwan.rgname
  location            = var.vwan.location
} 


resource "azurerm_virtual_hub" "vhub" {
  for_each = var.vhub
  name                = each.value.name
  resource_group_name = each.value.rgname
  location            = each.value.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = each.value.address_prefix
  dynamic "route" {
    for_each = var.route
    content {
      address_prefixes = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }
}


locals {
 hubidlist = [for hub in azurerm_virtual_hub.vhub : "${hub.id}"]
}

/*
resource "azurerm_express_route_gateway" "ergateway" {
  depends_on = [azurerm_virtual_hub.vhub]
  for_each = var.ergateway
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  virtual_hub_id = "${[for hub in azurerm_virtual_hub.vhub[each.key] : hub.id]}"
 # virtual_hub_id =  local.hubidlist[*].id
 # virtual_hub_id = azurerm_virtual_hub.vhub.*.ID
 # virtual_hub_id =  tostring(azurerm_virtual_hub.vhub[each.key].id)
 # virtual_hub_id = azurerm_virtual_hub.vhub[each.key].id
  scale_units =  5
  }


#index = range(length(var.vhub))
*/ 
