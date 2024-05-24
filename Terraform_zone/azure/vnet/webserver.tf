# Creating public 
resource "azurerm_public_ip" "web" {
  name                = "web"
  resource_group_name = azurerm_resource_group.ntier.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Dev"


  }
  depends_on = [azurerm_resource_group.ntier]

}
# Creating network security group
resource "azurerm_network_security_group" "web" {
  name                = "openhttpssh"
  resource_group_name = azurerm_resource_group.ntier.name
  location            = var.location

  tags = {
    Environment = "Dev"

  }
  depends_on = [azurerm_resource_group.ntier]
}




# creating network interface 

resource "azurerm_network_interface" "webnic" {
  name                = "webnic"
  location            = var.location
  resource_group_name = azurerm_resource_group.ntier.name
  ip_configuration {
    name                          = "web"
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }

  depends_on = [azurerm_subnet.subnets,
  azurerm_public_ip.web]
}

#Associate network interface to network security group

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.webnic.id
  network_security_group_id = azurerm_network_security_group.web.id

  depends_on = [azurerm_network_interface.webnic,
  azurerm_subnet.subnets]
}

# Creating Virtual Machine
resource "azurerm_virtual_machine" "web" {
  name                = "web"
  resource_group_name = azurerm_resource_group.ntier.name
  location            = var.location
  vm_size             = var.web_vm_info.vm_size

  os_profile {
    computer_name  = var.web_vm_info.name
    admin_username = var.web_vm_info.admin_username
    custom_data    = file("user_data.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = "true"
    ssh_keys {
      path     = var.web_vm_info.key_path
      key_data = file(var.web_vm_info.key_data)
    }

  }

  network_interface_ids = [azurerm_network_interface.webnic.id]
  storage_os_disk {
    name              = "webdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.web_vm_info.disk_type
  }

  storage_image_reference {
    publisher = var.web_vm_info.publisher
    offer     = var.web_vm_info.offer
    sku       = var.web_vm_info.sku
    version   = var.web_vm_info.version
  }


  depends_on = [azurerm_resource_group.ntier,
  azurerm_network_security_group.web]
}

