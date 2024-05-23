resource "aws_vpc" "dev" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
    Env  = terraform.workspace
  }
}