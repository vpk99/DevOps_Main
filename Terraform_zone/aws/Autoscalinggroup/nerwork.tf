module "vpc" {
  source       = "github.com/vpk99/DevOps_Main/Terraform_zone/aws/modules/vpc"
  network_info = var.network_info

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets


}

module "security_group" {
  source = "github.com/vpk99/DevOps_Main/Terraform_zone/aws/modules/security_group"
  security_group_info = {
    name             = var.security_group_info.name
    description      = var.security_group_info.name
    vpc_id           = module.vpc.vpc_id
    inbound_rules    = var.security_group_info.inbound_rules
    outbound_rules   = var.security_group_info.outbound_rules
    allow_all_egress = var.security_group_info.allow_all_egress
  }

  depends_on = [module.vpc]
}
