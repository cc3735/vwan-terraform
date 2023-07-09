variable "resource_groups" {
  type = map(object({
    name = string
    location = string
  }))
  default = {
    "RG1" = {
        name = "myRG"
        location = "eastus2"
    }
  }
}

variable "vwan" {
    type = map
    default = {
        name = "myVWAN"
        rgname = "myRG"
        location = "eastus2"
    }
}

variable "vhub" {
  type = map(object({
    name = string
    location = string
    rgname = string
    address_prefix = string
  }))
  default = {
    "Hub1" = {
        name = "myVWAN_hub1"
        rgname = "myRG"
        location = "eastus2"
        address_prefix = "10.0.0.1/24"
    }
    "Hub2" = {
        name = "myVWAN_hub2"
        rgname = "myRG"
        location = "eastus2"
        address_prefix = "100.0.0.1/24"
    }
  }
}

/* 
variable "vhub_test" {
  type = map
  default = { 
        name = "myVWAN_hub1"
        rgname = "myRG"
        location = "eastus2"
        address_prefix = "10.0.0.1/24"
  }
  {
        name = 
        rgname = 
        location
        address_prefix = ""
  }
}

*/

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


variable "ergateway" {
  type = map(object({
    name = string
    resource_group_name = string
    location = string
  }))
  default = {
    "gateway-eus" = {
        name = "test-eus2"
        resource_group_name = "MyRG"
        location = "eastus2"

    }
        "gateway-cus2" = {
        name = "test-cus"
        resource_group_name = "MyRG"
        location = "centralus"
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
  }
}


