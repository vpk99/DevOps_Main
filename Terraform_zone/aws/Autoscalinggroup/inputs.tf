variable "network_info" {
  type = object({
    name = string
    cidr = string
  })
  description = "vpc info"
  default = {
    name = "ntier"
    cidr = "10.0.0.0/16"
  }
}

variable "public_subnets" {
  type = list(object({
    name       = string
    az         = string
    cidr_block = string
  }))
}

variable "private_subnets" {
  type = list(object({
    name       = string
    az         = string
    cidr_block = string
  }))
}

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