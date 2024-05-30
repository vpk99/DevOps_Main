variable "vmss_info" {
  type = object({
    name = string
    resource_group_name = string
    location = string
    upgrade_mode = string
    admin_username = string
   instances = number
   key_path = string
  })
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer = string
    sku = string
    version = string

  })
}

variable "nic_info" {
  type = object({
    name = string
    subnet_id = string
    ip_name = string

  })
}

