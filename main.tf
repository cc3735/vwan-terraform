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
  name                = each.key
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


resource "azurerm_express_route_gateway" "ergateway" {
  depends_on = [azurerm_virtual_hub.vhub]
  for_each = azurerm_virtual_hub.vhub
  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  virtual_hub_id = azurerm_virtual_hub.vhub["${each.key}"].id
  scale_units =  5
  }


# We need to import the existing express route port example 

# terraform import azurerm_express_route_port.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/group1/providers/Microsoft.Network/expressRoutePorts/port1

#####

data "azurerm_express_route_circuit" "example" {
  for_each = azurerm_express_route_gateway.ergateway
  resource_group_name = each.value.resource_group_name
  name = each.key
} 


resource "azurerm_express_route_circuit_peering" "example" {
  for_each = azurerm_express_route_gateway.ergateway
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = "${data.azurerm_express_route_circuit.example[each.key].name}"
  resource_group_name           = "${data.azurerm_express_route_circuit.example[each.key].resource_group_name}"
  shared_key                    = "ItsASecret"
  peer_asn                      = 100
  primary_peer_address_prefix   = "192.168.1.0/30"
  secondary_peer_address_prefix = "192.168.2.0/30"
  vlan_id                       = 100
}

resource "azurerm_express_route_connection" "example" {
  for_each = azurerm_express_route_gateway.ergateway
  name                             = "example-expressrouteconn"
  express_route_gateway_id         = "${azurerm_express_route_gateway.ergateway[each.key].id}"
  express_route_circuit_peering_id = "${azurerm_express_route_circuit_peering.example[each.key].id}"
}

resource "azurerm_virtual_network" "Transithubs" {
  for_each = var.Transithubs
  name = each.key
  address_space = each.value.address_space #list
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_servers =  each.value.dns_servers
#dynamic "fwsubnets" {
#  for_each = var.fwsubnets
#  content {
#    name = fwsubnets.value.address_prefixes
#    address_prefix = fwsubnets.value.address_prefix
#    security_group = ""
#  }
#}
}

resource "azurerm_subnet" "azfwsubnet" {
  for_each = var.Transithubs
  name                 = "AZURE-FW-${each.key}"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.Transithubs[each.key].name
  address_prefixes     = each.value.azfw_subnet_address_prefix
}

resource "azurerm_subnet" "azfwmanagementsubnet" {
  for_each =  var.Transithubs
  name                 = "Azure-FW-MGMT${each.key}"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.Transithubs[each.key].name
  address_prefixes     = each.value.azfw_mgmt_subet_address_prefix
}



data "azurerm_resource_group" "resource_groups" {
  for_each = var.Transithubs
  name = azurerm_virtual_network.Transithubs[each.key].resource_group_name
}

resource "azurerm_public_ip" "fw_publicip" {
  for_each = azurerm_subnet.azfwsubnet
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_subnet.azfwsubnet[each.key].resource_group_name
  location            = data.azurerm_resource_group.resource_groups[each.key].location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "fw_management_publicip" {
  for_each = azurerm_subnet.azfwmanagementsubnet
  name                = "acceptanceTestPublicIp2"
  resource_group_name = azurerm_subnet.azfwmanagementsubnet[each.key].resource_group_name
  location            = data.azurerm_resource_group.resource_groups[each.key].location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}


resource "azurerm_firewall" "example" {
  for_each = azurerm_virtual_network.Transithubs
  name                = "testfirewall"
  location            = data.azurerm_resource_group.resource_groups[each.key].location
  resource_group_name = azurerm_subnet.azfwsubnet[each.key].resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.azfwsubnet[each.key].id
    public_ip_address_id = azurerm_public_ip.fw_publicip[each.key].id
  }

  management_ip_configuration {
    name = "configuration"
    subnet_id = azurerm_subnet.azfwmanagementsubnet[each.key].id
    public_ip_address_id = azurerm_public_ip.fw_management_publicip[each.key].id
  }
}
