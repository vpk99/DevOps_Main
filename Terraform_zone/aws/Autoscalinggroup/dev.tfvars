network_info = {
  name = "ntier"
  cidr = "192.168.0.0/16"
}

public_subnets = [{
  name       = "public-1"
  az         = "us-east-1a"
  cidr_block = "192.168.1.0/24"
  }, {
  name       = "public-2"
  az         = "us-east-1b"
  cidr_block = "192.168.2.0/24"
}]

private_subnets = [{
  name       = "private-1"
  az         = "us-east-1a"
  cidr_block = "192.168.3.0/24"
  }, {
  name       = "private-1"
  az         = "us-east-1a"
  cidr_block = "192.168.4.0/24"
}]

security_group_info = {
  name        = "web-sg"
  description = "inbound and outbound rules"
  vpc_id      = ""
  inbound_rules = [{
    cidr        = "0.0.0.0/0"
    from_port   = 22
    ip_protocol = "tcp"
    to_port     = 22
    description = "open ssh"
    }, {
    cidr        = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
    description = "open http"

  }]
  outbound_rules   = []
  allow_all_egress = true

}

launch_template = {
  instance_type = "t2.micro"
  key_name      = "my_idrsa"
  name          = "preschool-lt"
}