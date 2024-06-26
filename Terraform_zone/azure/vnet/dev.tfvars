network_cidr = ["10.0.0.0/16"]
subnet_names = ["bussiness", "web", "data"]
subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
network_name = "ntier"
location     = "eastus"
web_nsg_rules = [{
  name                       = "openhttp"
  description                = "This rule is for open http port"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  access                     = "Allow"
  priority                   = 1000
  direction                  = "Inbound"
  }, {

  name                       = "openssh"
  description                = "This rule is for open ssh port"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  access                     = "Allow"
  priority                   = 1010
  direction                  = "Inbound"
}]



web_vm_info = {
  name      = "web"
  size      = "Standard_B1s"
  username  = "web"
  key_path  = "~/.ssh/id_rsa.pub"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"

}