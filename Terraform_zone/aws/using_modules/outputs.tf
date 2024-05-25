output "vpc" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "instance_ips" {
  value = [for instance in module.instance : instance.public_ip]
}

output "urls" {
  value = [for instance in module.instance : "http://${instance.public_ip}/preschool"]
}

output "security_group_id" {
  value = module.aws_security_group
}