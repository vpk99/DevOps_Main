


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
  description = "public subnets"
  default = [{
    name       = "web1"
    az         = "us-east-1a"
    cidr_block = "10.0.0.0/24"
  }]
}

variable "private_subnets" {
  type = list(object({
    name       = string
    az         = string
    cidr_block = string
  }))
  description = "private subnets"
  default = [{
    name       = "db1"
    az         = "us-east-1c"
    cidr_block = "10.0.3.0/24"
  }]

}


variable "ami_id" {
  type        = string
  description = "ami id of ubuntu 24"
  default     = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t2.micro"
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
    outbond_rules = list(object({
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