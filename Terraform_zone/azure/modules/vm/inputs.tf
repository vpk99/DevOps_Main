variable "web_vm_info" {
  type = object({
    name           = string
    admin_username = string
    vm_size        = string
    key_path       = string
    key_data       = string
    disk_type      = string
    publisher      = string
    offer          = string
    sku            = string
    version        = string
    custom_data = bool
    custom_data_file = string
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