variable "network_info" {
type = object
description = "virtual network information"
default = {
  name = "ntier"
  location = "eastus"
  address_space = "10.0.0.0/16"

}
}


variable "subnet_info" {
  type = object({
    name = list(string)
    cidr = list(string)
    nsg_rules = list(object({
      name = string
      description = string
      source_port_range = string
      destination_port_range = string
      source_address_prefix = string
      destination_address_prefix = string
      access = string
      priority = string
      direction = string
    }))

  })
}