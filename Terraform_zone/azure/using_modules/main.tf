module "vnet" {
  source       = "github.com/vpk99/DevOps_Main/Terraform_zone/azure/modules/vnet"
  network_name = "ntier"
  network_cidr = ["10.0.0.0/16"]
  location     = "eastus"
  subnet_names = ["web1", "web2"]
  subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "nsg" {
  source = "github.com/vpk99/DevOps_Main/Terraform_zone/azure/modules/NSG"
  web_nsg_rules = [{
    name                       = "openssh"
    description                = "opens 22 port"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 1000
    direction                  = "Inbound"

    }, {
    name                       = "openhttp"
    description                = "opens 22 port"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 1010
    direction                  = "Inbound"

  }]
}