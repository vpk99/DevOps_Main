output "subnet_id" {
  value = module.vnet.subnet_ids
}

output "public_ip_address_id" {
  value = module.nsg.public_ip_address_id
}