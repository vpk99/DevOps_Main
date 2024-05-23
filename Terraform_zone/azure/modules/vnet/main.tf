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

