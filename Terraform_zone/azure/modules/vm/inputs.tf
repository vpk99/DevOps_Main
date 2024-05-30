variable "web_vm_info" {
  type = object({
    name      = string
    size      = string
    username  = string
    key_path  = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "resource_group_name" {
  type = string
  
}

variable "location" {
  type = string

}

variable "nic_info" {
  type = object({
    name = string
    subnet_id = string
    public_ip_address_id = string
  })
}

variable "network_security_group_id" {
  type = string
}

variable "file_name" {
  type = string
}