variable "region" {
  description = "Region where spin up environment"
}

variable "alt_region" {
  description = "Alternative region where spin up environment"
}


variable "aws_key" {
  description = "Desired key which you want to use for access"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for VPC"
}

variable "public_subnet_cidr_a" {
  type        = string
  description = "CIDR for public subnet A"
}

variable "public_subnet_cidr_b" {
  type        = string
  description = "CIDR for public subnet B"
}
