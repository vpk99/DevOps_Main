resource "aws_instance" "this" {
  ami                         = var.instance_info.ami
  associate_public_ip_address = var.instance_info.associate_public_ip_address
  instance_type               = var.instance.key_name
  key_name                    = var.instance_info.key_name
  vpc_security_group_ids      = [var.instance_info.security_group_id]
  subnet_id                   = var.instance_info.subnet_id

  user_data = var.instance_info.user_data ? file(var.instance_info.user_data_file) : ""


  tags = {
    Name = var.instance_info.name
  }

  
}