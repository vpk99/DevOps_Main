# Creating network interface 

resource "azurerm_network_interface" "webnic" {
  name                = "webnic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = var.nic_info.name
    subnet_id                     = var.nic_info.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.nic_info.public_ip_address_id
  }


}


#Associate network interface to network security group

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.webnic.id
  network_security_group_id = var.network_security_group_id

}

# Creating Virtual Machine

resource "azurerm_linux_virtual_machine" "web" {
  name                  = var.web_vm_info.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.web_vm_info.size
  admin_username        = var.web_vm_info.username
  network_interface_ids = [azurerm_network_interface.webnic.id]
  admin_ssh_key {
    username   = var.web_vm_info.username
    public_key = file(var.web_vm_info.key_path)

  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.web_vm_info.publisher
    offer     = var.web_vm_info.offer
    sku       = var.web_vm_info.sku
    version   = var.web_vm_info.version
  }
  custom_data = filebase64("install.sh")
}
