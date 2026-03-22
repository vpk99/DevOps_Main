# Creating security group

resource "aws_security_group" "this" {
  name        = var.security_group_info.name
  description = var.security_group_info.description
  vpc_id      = var.security_group_info.vpc_id

  tags = {
    Name = var.security_group_info.name
  }
  
}

#inbound rules
resource "aws_vpc_security_group_ingress_rule" "this_inbound" {
  count             = length(var.security_group_info.inbound_rules)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.security_group_info.inbound_rules[count.index].cidr
  from_port         = var.security_group_info.inbound_rules[count.index].from_port
  ip_protocol       = var.security_group_info.inbound_rules[count.index].ip_protocol
  to_port           = var.security_group_info.inbound_rules[count.index].to_port

  depends_on = [aws_security_group.this]

}

#Outbound rules 

resource "aws_vpc_security_group_egress_rule" "this_outbound" {
  count             = length(var.security_group_info.outbound_rules)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.security_group_info.outbound_rules[count.index].cidr
  from_port         = var.security_group_info.outbound_rules[count.index].from_port
  ip_protocol       = var.security_group_info.outbound_rules[count.index].ip_protocol
  to_port           = var.security_group_info.outbound_rules[count.index].to_port

  depends_on = [aws_security_group.this]
}

# Allow  all outbound rules 

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  count             = var.security_group_info.allow_all_egress ? 1 : 0
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  depends_on = [aws_security_group.this]
}