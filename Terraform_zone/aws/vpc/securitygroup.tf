# Creating security group

resource "aws_security_group" "web_sg" {
  name        = var.security_group_info.name
  description = var.security_group_info.description
  vpc_id      = aws_vpc.ntier.id

  tags = {
    Name = var.security_group_info.name
  }
  depends_on = [aws_vpc.ntier]
}

#Inbound rules
resource "aws_vpc_security_group_ingress_rule" "web_sg_inbound" {
  count             = length(var.security_group_info.inbound_rules)
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = var.security_group_info.inbound_rules[count.index].cidr
  from_port         = var.security_group_info.inbound_rules[count.index].from_port
  ip_protocol       = var.security_group_info.inbound_rules[count.index].ip_protocol
  to_port           = var.security_group_info.inbound_rules[count.index].to_port

  depends_on = [aws_security_group.web_sg]

}

#Outbound rules 

resource "aws_vpc_security_group_egress_rule" "web_sg_outbound" {
  count             = length(var.security_group_info.outbond_rules)
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = var.security_group_info.outbond_rules[count.index].cidr
  from_port         = var.security_group_info.outbond_rules[count.index].from_port
  ip_protocol       = var.security_group_info.outbond_rules[count.index].ip_protocol
  to_port           = var.security_group_info.outbond_rules[count.index].to_port

  depends_on = [aws_security_group.web_sg]
}

# Allow  all outbound rules 

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  count             = var.security_group_info.allow_all_egress ? 1 : 0
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  depends_on = [aws_security_group.web_sg]
}