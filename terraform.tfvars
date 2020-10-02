aws_key = "epam"
region  = "eu-north-1"
amis = {
  "eu-north-1" = "ami-0653812935d0743fe"
}
remote_state_s3      = "max2020state"
vpc_cidr             = "10.100.0.0/16"
public_subnet_cidr_a = "10.100.10.0/24"
public_subnet_cidr_b = "10.100.20.0/24"
