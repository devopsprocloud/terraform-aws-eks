terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 6.9.0, < 7.0.0"
    }
  }

  backend "s3"{
  bucket = "devopsprocloud-remote-state"
  key = "roboshop-eks"
  region = "us-east-1"
  dynamodb_table = "devopsprocloud-remote-state-lock"
}
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}