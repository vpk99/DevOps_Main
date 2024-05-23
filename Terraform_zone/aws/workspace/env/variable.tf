variable "vpc_name" {
  type        = string
  description = "vpc name"
  default     = "ntier"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr range"
  default     = "10.0.0.0/16"
}