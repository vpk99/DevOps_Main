variable "web_nsg_rules" {
  type = list(object({
    name                       = string
    description                = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    access                     = string
    priority                   = number
    direction                  = string

  }))
}

variable "location" {
  type = string
  default = "eastus"
}

variable "resource_group_name" {
type = string
default = "ntier"
}

variable "Public_ip_name" {
  type = string
}

variable "network_interface_name" {
  type = string
}