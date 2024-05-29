# Creating Virtual Machine
resource "azurerm_virtual_machine" "web" {
  name                = var.network_info.name
  resource_group_name = var.resource_group_name
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

