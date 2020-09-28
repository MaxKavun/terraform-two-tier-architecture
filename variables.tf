variable "region" {
  description = "Region where spin up environment"
}

variable "aws_key" {
  description = "Desired key which you want to use for access"
}

variable "amis" {
  type        = map
  description = "Map with AMIs which exist in region"
}
