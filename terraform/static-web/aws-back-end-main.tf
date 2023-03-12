/* ## USE THIS FOR AWS BACKEND

# terraform {
# backend "s3" {
#  bucket         = "kaokakelvin-nginx-static-web"
#  key            = "terraform/static-web/terraform.tfstate"
#  region         = "us-east-1"
#  dynamodb_table = "terraform-state-locking-nginx-static-web"
#  encrypt        = true
# }
comment out backend section to create required resources first. run locally then on pipeline

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "kaokakelvin-nginx-static-web"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-sse" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking-nginx-static-web"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
} */