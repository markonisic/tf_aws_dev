terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/markon/.aws/credentials"
  profile                 = "tf-admin"
}