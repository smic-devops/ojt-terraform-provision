# provider.tf
terraform {
  required_version = ">= 1.6"



  required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = ">= 5.0"
   }
  }
}



provider "aws" {
  region     = "ap-southeast-1"
  access_key = "insert your access key here"
  secret_key = "insert your secret key here"
  token      = "insert your token here"
}