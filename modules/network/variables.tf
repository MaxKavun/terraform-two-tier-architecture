variable "vpc_cidr" {
  type = string
  description = "CIDR for VPC network"
}

variable "public_subnet_cidr_a" {
  type = string
  description = "CIDR for public subnet A"
}

variable "public_subnet_cidr_b" {
  type = string
  description = "CIDR for public subnet B"
}
