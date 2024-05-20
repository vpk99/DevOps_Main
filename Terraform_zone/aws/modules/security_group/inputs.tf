variable "security_group_info" {
  type = object({
    name        = string
    description = string
    vpc_id      = string
    inbound_rules = list(object({
      cidr        = string
      from_port   = number
      ip_protocol = string
      to_port     = number
      description = string
    }))
    outbound_rules = list(object({
      cidr        = string
      from_port   = number
      ip_protocol = string
      to_port     = number
      description = string
    }))
   allow_all_egress = bool
  })
  description = "Security group info"
}