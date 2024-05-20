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