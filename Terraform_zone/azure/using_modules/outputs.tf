output "subnet_id" {
  value = module.vnet.subnet_ids
}

output "public_ip_address_id" {
  value = module.nsg.public_ip_address_id
}


output "web_ip" {
  value = module.vm.web_ip
}

output "url" {
  value = "http://${module.vm.web_ip}/preschool"
}