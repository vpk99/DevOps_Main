module "vnet" {
  source              = "github.com/vpk99/DevOps_Main/Terraform_zone/azure/modules/vnet"
  network_name        = "ntier-primary"
  network_cidr        = ["10.0.0.0/16"]
  location            = "eastus"
  subnet_names        = ["web1", "web2"]
  subnet_cidrs        = ["10.0.1.0/24", "10.0.2.0/24"]
  resource_group_name = "ntier"
}




module "nsg" {
  source = "../modules/NSG"
  location = "eastus"
  nsg_name = "web_nsg"
  resource_group_name = "ntier"
  public_ip_name = "web_ip"
  web_nsg_rules = [ {
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
  },{
   
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
  } ]
}

resource "azurerm_network_interface" "web_nic" {
  name = "webnic"
  location = "eastus"
  resource_group_name = "ntier"
ip_configuration {
  name = "web"
  subnet_id = module.vnet.subnet_ids[0]
  private_ip_address_allocation = "Dynamic"
  public_ip_address_id = module.nsg.public_ip_address_id
}

depends_on = [ module.vnet, module.nsg ]
}

resource "azurerm_network_interface_security_group_association" "nic_nsgname" {
  network_interface_id = azurerm_network_interface.web_nic.id
  network_security_group_id = module.nsg.network_security_group_id
}

##Creating a vm using module
#module "vm" {
#  source = "../modules/vm"
#  web_vm_info = {
#    name           = "vmweb"
#    admin_username = "ubuntu"
#    vm_size        = "Standard_B1s"
#    key_path       = "/home/ubuntu/.ssh/authorized_keys"
#    key_data       = "~/.ssh/id_rsa.pub"
#    disk_type      = "Standard_LRS"
#    publisher      = "canonical"
#    offer          = "0001-com-ubuntu-server-jammy"
#    sku            = "22_04-lts-gen2"
#    version        = "latest"
#
#  }
#}

