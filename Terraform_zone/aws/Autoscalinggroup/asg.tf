data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "web"
  }
}

resource "aws_launch_template" "preschool" {
  name                   = var.launch_template.name
  instance_type          = var.launch_template.instance_type
  image_id               = data.aws_ami.ubuntu.id
  key_name               = var.launch_template.key_name
  vpc_security_group_ids = [module.security_group.security_group_id]

  tags = {
    Name = "preschool"
  }
  user_data = filebase64("install.sh")

  depends_on = [module.vpc, data.aws_ami.ubuntu, module.security_group]
}

resource "aws_autoscaling_group" "preschool" {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  launch_template {
    id      = aws_launch_template.preschool.id
    version = "$Latest"
  }
  vpc_zone_identifier = module.vpc.public_subnets
  target_group_arns   = [aws_lb_target_group.preschool-tg.arn]


 
  depends_on = [module.vpc,
    aws_launch_template.preschool,
  module.security_group]

  
}