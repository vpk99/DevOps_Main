terraform {

   backend "s3" {
    bucket = "demo-backendtf"
    key    = "demo/backend"
    region = "us-east-1"
  }

 
}