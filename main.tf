terraform {
  backend "s3" {
    bucket = "max2020state"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "aws-admin"
}

resource "aws_instance" "example" {
  ami           = var.amis[var.region]
  instance_type = "t3.micro"
  subnet_id     = "subnet-0a57e2bff9477c93b"
  key_name      = var.aws_key
}

resource "aws_eip" "lb" {
  instance = aws_instance.example.id
  vpc      = true
}
