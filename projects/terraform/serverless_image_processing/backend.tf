terraform {
  backend "s3" {
    bucket         = "vinayak-project-backend-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "project-tf-eks-statelock"
    encrypt        = true
  }
}