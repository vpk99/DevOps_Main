output "subnet_id" {
  value = module.vnet.subnet_ids
}

output "public_ip_address_id" {
  value = module.nsg.public_ip_address_id
}


output "public_ip" {
  value = module.vm.vM_info
}
output "url" {
  value = "http://${module.vm.vM_info}}/preschool"
}