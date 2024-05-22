terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }
}

# Storing state files in s3 bucket 
terraform {
  backend "s3" {
    bucket = "tterraformstatebackend"
    key    = "terraform.tfstate"
    region = "us-east-1"

    # Enable state locking (recommended)
    dynamodb_table = "terraformbackend"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      CreatedBy   = "Terraform"
      Environment = "Dev"
    }
  }
}