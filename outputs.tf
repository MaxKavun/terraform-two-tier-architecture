output "asg_public_ip" {
  value = aws_lb.web_tier_alb.dns_name
}
