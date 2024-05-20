module "vpc" {
  source = "../modules/vpc"

  network_info = {
    name = "primary-network"
    cidr = "10.0.0.0/16"
  }
  public_subnets = [{
    name       = "web"
    az         = "us-east-1a"
    cidr_block = "10.0.0.0/24"
  }]
  private_subnets = [{
    name       = "data1"
    az         = "us-east-1b"
    cidr_block = "10.0.1.0/24"
    }, {
    name       = "data2"
    az         = "us-east-1c"
    cidr_block = "10.0.2.0/24"
  }]

}

# Creating security group using module

module "aws_security_group" {
  source = "../modules/security_group"
  security_group_info = {
    name        = "web-sg"
    description = "web security group"
    vpc_id      = module.vpc.vpc_id
    inbound_rules = [{
      cidr        = "0.0.0.0/0"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
      description = "open http"
      }, {
      cidr        = "0.0.0.0/0"
      from_port   = 22
      ip_protocol = "tcp"
      to_port     = 22
      description = "open ssh"
    }]
    outbound_rules   = []
    allow_all_egress = true
  }
  depends_on = [module.vpc]
}


# Creating a security group for sql database with port 3306 
module "db_security_group" {
  source = "../modules/security_group"
  security_group_info = {
    name        = "db_sg"
    description = "db security group"
    vpc_id      = module.vpc.vpc_id
    inbound_rules = [{
      cidr        = "0.0.0.0/0"
      from_port   = 3306
      ip_protocol = "tcp"
      to_port     = 3306
      description = "open mysql port in vpc"
    }]
    outbound_rules   = []
    allow_all_egress = true
  }

}