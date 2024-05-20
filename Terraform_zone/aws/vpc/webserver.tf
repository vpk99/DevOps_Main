# Creating EC2 instance

resource "aws_instance" "web" {
  ami                         = var.ami_id
  associate_public_ip_address = "true"
  instance_type               = var.instance_type
  key_name                    = "my_idrsa"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = aws_subnet.public[0].id


  user_data = file("user_data.sh")


  tags = {
    Name = "web"
  }

  depends_on = [aws_vpc.ntier, aws_subnet.public]
}