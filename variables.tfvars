vwan = {
    rgname = "VWANRGNAME"
    location = "east-us"
    name = "MyVWAN"
}

vwanhub = {
    vwanhub_east = {
            name = "VWANHUB-EAST"
            resource_group_name = ""
            location = ""
            virtual_wan_id = ""
            address_prefix = ""
            route{
                address_prefix = ""
                next_hop_ip_address = ""
            }

            tags = {
                Assetcode = "test"
            }
        }
        vwanhub_central = {
            name = ""
            resource_group_name = ""
            location = ""
            virtual_wan_id = ""
            address_prefix = ""
            tags = {
                Assetcode = "test"
            }
        }
}