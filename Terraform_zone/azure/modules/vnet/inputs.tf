variable "resource_group_name" {
  type = string
  default = "ntier"
}

variable "network_name" {
  type        = string
  description = "This is name for virtual network"
  
}

variable "location" {
  type        = string
  description = "Location for resource group and virtual network"

}


variable "network_cidr" {
  type        = list(string)
  description = "This cidr range for azure virtual network"

}

variable "subnet_names" {
  type        = list(string)
  description = "subnet names"
  
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "subnet cidrs"
  
}


