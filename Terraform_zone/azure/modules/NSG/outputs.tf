output "public_ip_address_id" {
  value = azurerm_public_ip.web.id
}

output "network_security_group_id" {
  value = azurerm_network_security_group.web.id
}