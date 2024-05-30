resource "azurerm_resource_group" "preschool" {
  name     = "preschool"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.preschool.name
  address_space       = ["10.0.0.0/16"]

}




resource "azurerm_subnet" "sub-1" {
  name                 = "sub-1"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.preschool.name
  address_prefixes     = ["10.0.0.0/24"]
}



resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.vmss_info.name
  resource_group_name = azurerm_resource_group.preschool.name
  location            = var.vmss_info.location
  sku                 = var.vmss_info.sku
  instances           = var.vmss_info.instances
  admin_username      = var.vmss_info.admin_username
  upgrade_mode        = var.vmss_info.upgrade_mode

  admin_ssh_key {
    username   = var.vmss_info.admin_username
    public_key = file(var.vmss_info.key_path)
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name = var.nic_info.name
    primary = true
    ip_configuration {
      name      = var.nic_info.ip_name
      subnet_id = azurerm_subnet.sub-1.id

    }

  }
}