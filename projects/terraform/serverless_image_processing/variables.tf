variable "project_name" {
  description = "project name used  for resource naming"
  type = string
  default = "image-proccessor"
}

variable "environment" {
  description = "environment name"
  type = string
  default = "dev"
}


variable "aws_region" {
  description = "Allowed regions"
  type = string
  default = "us-east-1"
}