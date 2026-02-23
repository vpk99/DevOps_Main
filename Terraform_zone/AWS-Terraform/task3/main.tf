resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.instance_type


  tags = {
    Name = "HelloWorld"
  }

lifecycle {
  create_before_destroy = true
}
}
