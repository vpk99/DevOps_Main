terraform {

   backend "s3" {
    bucket = "demo-backendtf"
    key    = "demo/backend"
    region = "us-east-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# create s3 bucket 

resource "aws_s3_bucket" "task-1" {
  bucket = "aw-terraform-task1-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}