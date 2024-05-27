output "subnet_ids" {
  value = [for subnet in vnet.subnet : subnet.id]
}
