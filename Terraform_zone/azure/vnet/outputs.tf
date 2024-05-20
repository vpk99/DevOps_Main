output "web_ip" {
  value = azurerm_public_ip.web.ip_address
}

output "web_url" {
  value = "http://${azurerm_public_ip.web.ip_address}/preschool"
}