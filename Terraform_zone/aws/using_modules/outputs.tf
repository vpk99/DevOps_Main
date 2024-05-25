output "vpc" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "instace_ip" {
  value = module.instance.public_ip
}

output "url" {
  value = "http://${module.instance.public_ip}/preschool"
}

output "security_group_id" {
  value = module.aws_security_group
}