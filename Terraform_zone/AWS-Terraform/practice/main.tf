terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.1"
    }
  }
}

provider "aws" {
  # Configuration options
}





resource "aws_s3_bucket" "example" {
 for_each = var.bucket_name_set
  bucket = each.value

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}