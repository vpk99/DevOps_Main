resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name = var.vmss_info.name
  resource_group_name = var.vmss_info.resource_group_name
  location = var.vmss_info.location
  sku = var.vmss_info.sku
  instances = var.vmss_info.instances
  admin_username = var.vmss_info.admin_username
  upgrade_mode = var.vmss_info.upgrade_mode

admin_ssh_key {
  username = var.vmss_info.admin_username
  public_key = var.vmss_info.key_path
}

source_image_reference {
  publisher = var.source_image_reference.publisher
  offer = var.source_image_reference.offer
  sku = var.source_image_reference.sku
  version = var.source_image_reference.version
}
os_disk {
  storage_account_type = "Standard_LRS"
  caching = "ReadWrite"
}

network_interface {
  name = var.nic_info.name
  ip_configuration {
    name = var.nic_info.ip_name
    subnet_id = var.nic_info.subnet_id
  }
}
}