resource "azurerm_resource_group" "ntier" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Env       = "Dev"
    CreatedBy = "Terraform"
  }
}

resource "azurerm_virtual_network" "ntier-primary" {
  name                = var.network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.network_cidr

  depends_on = [azurerm_resource_group.ntier]
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network_name
  address_prefixes     = [var.subnet_cidrs[count.index]]

  depends_on = [azurerm_virtual_network.ntier-primary]
}
