resource "azurerm_virtual_network" "ntier-primary" {
  name                = var.network_info.name
  resource_group_name = azurerm_resource_group.ntier.name
  location            = var.network_info.location
  address_space       = var.network_info.address_space

  
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_info)
  name                 = var.subnet_info[count.index].name
  resource_group_name  = azurerm_resource_group.ntier.name
  virtual_network_name = var.network_info.name
  address_prefixes     = var.subnet_info[count.index].address_prefixes


}

# Creating network security group rules
resource "azurerm_network_security_rule" "web" {
  count                       = length(var.subnet_info)
  name                        = var.subnet_info[count.index].name
  resource_group_name         = azurerm_resource_group.ntier.name
  network_security_group_name = azurerm_network_security_group.web.name
  description                 = var.subnet_info[count.index].description
  protocol                    = var.subnet_info[count.index].protocol
  source_port_range           = var.subnet_info[count.index].source_port_range
  destination_port_range      = var.subnet_info[count.index].destination_port_range
  source_address_prefix       = var.subnet_info[count.index].source_address_prefix
  destination_address_prefix  = var.subnet_info[count.index].destination_address_prefix
  access                      = var.subnet_info[count.index].access
  priority                    = var.subnet_info[count.index].priority
  direction                   = "Inbound"

