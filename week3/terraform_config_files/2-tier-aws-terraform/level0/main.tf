provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "terraform-remote-state-260523"
}

resource "aws_dynamodb_table" "terraform_remote_state" {
  name           = "terraform-remote-state-lock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_object" "directory" {
  bucket = aws_s3_bucket.terraform_remote_state.id
  key    = "key/"
  content = ""
}

terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-260523"
    key            = "key/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-remote-state-lock"

  }
}
