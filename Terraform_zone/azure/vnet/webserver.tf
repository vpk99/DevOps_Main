# Creating public ip 
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
resource "azurerm_linux_virtual_machine" "web" {
  name                  = var.web_vm_info.name
  resource_group_name   = azurerm_resource_group.ntier.name
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