variable "resource_groups" {
  type = map(object({
    name = string
    location = string
    subscription = string
  }))
  default = {
    "vwan-rg" = {
        name = "VWAN-rg"
        location = "eastus2"
        subscription = "true"
    }
     "vwanhub-eastus2-rg" = {
        name = "vwanhub-eastus2-rg"
        location = "eastus2"
        subscription = "true"
    }
     "vwanhub-central-rg" = {
        name = "Vwanhub-central-rg"
        location = "centralus"
        subscription = "true"
    }
    "dmzspoke1-eastus2-rg" = {
        name = "dmzspoke1-east-rg"
        location = "eastus2"
        subscription = "true"
    }
    "dmzspoke1-central-rg" = {
        name = "dmzspoke1-central-rg"
        location = "centralus"
        subscription = "true"
    }
  }
}

variable "vwan" {
    type = map
    default = {
        name = "VWAN"
        rgname = "VWAN-east-rg"
        location = "eastus2"
    }
}

variable "vhub" {
  type = map(object({
    name = string
    location = string
    rgname = string
    address_prefix = string
    subscription = string
  }))
  default = {
    "Hub1_east" = {
        name = "myVWAN_hub1"
        rgname = "myRG"
        location = "eastus2"
        address_prefix = "10.0.0.1/24"
        subscription = "iii"
    }
    "Hub2_central" = {
        name = "myVWAN_hub2"
        rgname = "myRG"
        location = "eastus2"
        address_prefix = "100.0.0.1/24"
        subscription = "yyy"
    }
  }
}

variable "route" {
  type = map(object({
    address_prefixes = list(string)
    next_hop_ip_address = string
  }))
  default = {
    "route1" = {
        address_prefixes = ["1.0.0.0/24"]
        next_hop_ip_address = "1.1.1.1"
    }
  }
}

variable "default_rt_east_routes" {
  type = map(object({
    name = string
    destinations_type = string
    destinations = list(string)
    next_hop_type = string
  }))
  default = {
    "route1": {
      name = "test"
      destinations_type = "CIDR"
      destinations = ["10.1.1.1/16"]
      next_hop_type = "ResourceID"
    },
    "route2": {
      name = "test2"
      destinations_type = "CIDR"
      destinations = ["10.1.1.2/16"]
      next_hop_type = "ResourceID"
    }
  }
}

/* 
variable "default_rt_east_routes2" {
  type = list(object({
    name = string
    destinations_type = string
    destinations = list(string)
    next_hop_type = string
    next_hop = string
    next_hop_ip_address = string
  }))
  default = [{
    name = "stuff1"
    destinations = [ "10.1.1.1" ]
    destinations_type = "CIDR"
    next_hop = "value"
    next_hop_type = "ResourceID"
  },
  {
      name = "test2"
      destinations_type = "CIDR"
      destinations = ["10.1.1.1"]
      next_hop_type = "ResourceID"
      next_hop_ip_address = "1.1.1.1"
      next_hop = ""
  }]
}
*/


variable "ergateway" {
  type = map(object({
    name = string
    resource_group_name = string
    location = string
    bgp_peer_asn = string
    bgp_primary_peer_address_prefix = string
    bgp_secondary_peer_address_prefix = string
    bgp_vlan_id = number
  }))
  default = {
    "ergateway-eus2" = {
        name = "EXPRESSROUTE_GATEWAY_NAME"
        resource_group_name = "MyRG"
        location = "eastus2"
        bgp_peer_asn = "100"
        bgp_primary_peer_address_prefix = "192.168.1.0/30"
        bgp_secondary_peer_address_prefix = "192.168.2.0/30"
        bgp_vlan_id = 100
    }
        "ergateway-cus" = {
        name = "EXPRESSROUTE_GATEWAY_NAME"
        resource_group_name = "MyRG"
        location = "centralus"
        bgp_peer_asn = "100"
        bgp_primary_peer_address_prefix = "192.168.3.0/30"
        bgp_secondary_peer_address_prefix = "192.168.4.0/30"
        bgp_vlan_id = 100
    }
  }
}


variable "Transithubs" {
  type = map(object({
    name = string
    resource_group_name = string
    location = string
    address_space = list(string)
    resource_group_name = string
    dns_servers = list(string)
    azfw_subnet_address_prefix = list(string)
    azfw_mgmt_subet_address_prefix = list(string)
  }))
  default = {
    "TransitHub1" = {
        name = "test"
        address_space = ["10.0.1.0/24"]
        resource_group_name = "MyRG"
        location = "eastus2"
        dns_servers = ["8.8.8.8"]
        azfw_subnet_address_prefix = ["10.0.1.0/27"]
        azfw_mgmt_subet_address_prefix = ["10.0.1.100/27"]
    }
    "TransitHub2" = {
        name = "test"
        address_space = ["10.0.1.0/24"]
        resource_group_name = "MyRG"
        location = "eastus2"
        dns_servers = ["8.8.8.8"]
        azfw_subnet_address_prefix = ["10.0.1.0/27"]
        azfw_mgmt_subet_address_prefix = ["10.0.1.100/27"]
  }
}
}

