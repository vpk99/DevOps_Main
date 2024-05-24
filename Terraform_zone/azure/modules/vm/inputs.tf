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
  })
}

variable "resource_group_name" {
  type = string
  default = "ntier"
}

variable "location" {
  type = string
  default = "eastus"
}