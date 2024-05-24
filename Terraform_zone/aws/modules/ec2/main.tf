
# Creating EC2 instance

resource "aws_instance" "web" {
  ami                         = var.vm_info.ami
  associate_public_ip_address = var.vm_info.associate_public_ip_address
  instance_type               = var.vm_info.instance_type
  key_name                    = var.vm_info.key_name
  vpc_security_group_ids      = [var.vm_info.security_group_id]
  subnet_id                   = var.vm_info.subnet_id


  user_data = file("user_data.sh")


  tags = {
    Name = "web"
  }


}