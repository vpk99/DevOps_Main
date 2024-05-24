resource "azurerm_resource_group" "ntier" {
  name     = "ntier"
  location = var.location
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
}

resource "azurerm_virtual_network" "ntier-primary" {
  name                = var.network_name
  resource_group_name = azurerm_resource_group.ntier.name
  location            = var.location
  address_space       = var.network_cidr

  depends_on = [azurerm_resource_group.ntier]
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.ntier.name
  virtual_network_name = azurerm_virtual_network.ntier-primary.name
  address_prefixes     = [var.subnet_cidrs[count.index]]

  depends_on = [azurerm_virtual_network.ntier-primary]
}

# Creating network security group rules
resource "azurerm_network_security_rule" "web" {
  count                       = length(var.web_nsg_rules)
  name                        = var.web_nsg_rules[count.index].name
  resource_group_name         = azurerm_resource_group.ntier.name
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

  depends_on = [azurerm_network_security_group.web]
}