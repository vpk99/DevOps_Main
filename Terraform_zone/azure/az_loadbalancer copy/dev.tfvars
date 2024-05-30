vmss_info = {
  name                = "preschool-vmss"
  resource_group_name = "ntier"
  location            = "eastus"
  upgrade_mode        = "Manual"
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "preschool"
  key_path            = "~/.ssh/id_rsa.pub"

}

source_image_reference = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"

}

nic_info = {
  name      = "preschool-nic"
  subnet_id = ""
  ip_name   = "preschool_ip"
}