
#resource "azurerm_public_ip" "web" {
#  name                = var.Public_ip_name
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  allocation_method   = "Static"
#  sku                 = "Standard"
#
#  tags = {
#    Environment = "Dev"
#
#
#  }
#}

# Creating network security group
resource "azurerm_network_security_group" "web" {
  name                = "openhttpssh"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = {
    Environment = "Dev"

  }
  
}

# Creating network security group rules
resource "azurerm_network_security_rule" "web" {
  count                       = length(var.web_nsg_rules)
  name                        = var.web_nsg_rules[count.index].name
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web.name
  description                 = var.web_nsg_rules[count.index].description
  protocol                    = var.web_nsg_rules[count.index].protocol
  source_port_range           = var.web_nsg_rules[count.index].source_port_range
  destination_port_range      = var.web_nsg_rules[count.index].destination_port_range
  source_address_prefix       = var.web_nsg_rules[count.index].source_address_prefix
  destination_address_prefix  = var.web_nsg_rules[count.index].destination_address_prefix
  access                      = var.web_nsg_rules[count.index].access
  priority                    = var.web_nsg_rules[count.index].priority
  direction                   = "Inbound"
}



## creating network interface 
#
#resource "azurerm_network_interface" "webnic" {
#  name                = "webnic"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  ip_configuration {
#    name                          = "web"
#    subnet_id                     = var.subnet_id
#    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = azurerm_public_ip.web.id
#  }
#
#  
#}
#
##Associate network interface to network security group
#
#resource "azurerm_network_interface_security_group_association" "nic_nsg" {
#  network_interface_id      = azurerm_network_interface.webnic.id
#  network_security_group_id = azurerm_network_security_group.web.id
#}