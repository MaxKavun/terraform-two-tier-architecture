output "alb_sg" {
  value = aws_security_group.alb_rules.id
}

output "web_tier_sg" {
  value = aws_security_group.web_tier_rules.id
}

output "subnet_a" {
  value = aws_subnet.public_a.id
}

output "subnet_b" {
  value = aws_subnet.public_b.id
}

output "main_vpc" {
  value = aws_vpc.main.id
}
