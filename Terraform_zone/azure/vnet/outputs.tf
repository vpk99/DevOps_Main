output "web_ip" {
  value = azurerm_linux_virtual_machine.web.id
}

output "web_url" {
  value = "http://${azurerm_linux_virtual_machine.web.id}/preschool"
}

output "subnet_ids" {
  value = azurerm_subnet.subnets[*].id
}
