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





# Creating Virtual Machine
resource "azurerm_virtual_machine" "web" {
  name                = var.web_vm_info.name
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_size             = var.web_vm_info.vm_size

  os_profile {
    computer_name  = var.web_vm_info.name
    admin_username = var.web_vm_info.admin_username
    custom_data    = var.web_vm_info.custom_data ? file(var.web_vm_info.custom_data_file): ""
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


  
}

