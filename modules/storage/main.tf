terraform {
  # Define version constaint for use this module only with provider version 3.7.0
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7.0"
    }
  }
}

resource "aws_s3_bucket" "session_store" {
  bucket = "session_store"
  tags = {
    Name        = "session_store"
  }
}
