provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = var.s3_buckent_name
}

resource "aws_dynamodb_table" "terraform_remote_state" {
  name           = var.table_name
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
    bucket         = var.s3_buckent_name
    key            = "key/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = var.table_name

  }
}