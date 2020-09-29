terraform {
  # Define version constaint for use this module only with provider version 3.7.0
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# TODO: Add route table with association
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.100.10.0/24"
  map_public_ip_on_launch = true
}

# TODO: Add route table with association
resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.100.20.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "alb_rules" {
  name = "alb_rules"
  vpc_id = aws_vpc.main.id
  ingress {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_tier_rules" {
  name = "web_tier_rules"
  vpc_id = aws_vpc.main.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "web_tier_sg" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.alb_rules.id
  security_group_id = aws_security_group.web_tier_rules.id
}
