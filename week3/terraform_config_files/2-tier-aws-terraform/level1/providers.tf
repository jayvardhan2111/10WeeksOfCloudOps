provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-remote-state-260523"
    key    = "key/level1.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-remote-state-lock"

  }
}