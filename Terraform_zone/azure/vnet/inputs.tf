variable "network_name" {
  type        = string
  description = "This is name for virtual network"
  default     = "ntier"
}

variable "location" {
  type        = string
  description = "Location for resource group and virtual network"
  default     = "eastus"
}


variable "network_cidr" {
  type        = list(string)
  description = "This cidr range for azure virtual network"
  default     = ["10.0.0.0/16"]
}

variable "subnet_names" {
  type        = list(string)
  description = "subnet names"
  default     = ["bussiness", "web", "data"]
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "subnet cidrs"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

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

  description = "security rules for web nsg"
  default = [{
    name                       = "openhttp"
    description                = "this rule for open http port"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 1000
    direction                  = "Inbound"
  }]
}

variable "web_vm_info" {
  type = object({
    name      = string
    size      = string
    username  = string
    key_path  = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "vm machine info"
  default = {
    name      = "web"
    size      = "Standard_B1s"
    username  = "web"
    key_path  = "~/.ssh/id_rsa.pub"
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}

