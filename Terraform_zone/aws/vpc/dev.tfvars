network_info = {
  name = "ntier"
  cidr = "10.0.0.0/16"
}

public_subnets = [{
  name       = "web1"
  az         = "us-east-1a"
  cidr_block = "10.0.0.0/24"
  }, {
  name       = "web2"
  az         = "us-east-1b"
  cidr_block = "10.0.1.0/24"
}]

private_subnets = [{
  name       = "data1"
  az         = "us-east-1c"
  cidr_block = "10.0.2.0/24"
  }, {
  name       = "data2"
  az         = "us-east-1d"
  cidr_block = "10.0.3.0/24"
}]


security_group_info = {
  name        = "web_sg"
  description = "secrity group and inbound,outbound rules"
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
  outbond_rules    = []
  allow_all_egress = true
}

instance_type = "t2.micro"

ami_id = "ami-04b70fa74e45c3917"