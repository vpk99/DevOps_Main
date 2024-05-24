variable "vm_info" {
  type = object({
    name                        = string
    associate_public_ip_address = bool
    instance_type               = string
    key_name                    = string
    security_group_id           = string
    subnet_id                   = string
    ami                         = string
  })

}



    