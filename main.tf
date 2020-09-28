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

resource "aws_launch_template" "web_tier" {
  name = "web_tier"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }
  image_id               = var.amis[var.region]
  instance_type          = "t3.micro"
  key_name               = var.aws_key
  user_data              = filebase64("${path.module}/provisions/web-tier.sh")
  vpc_security_group_ids = ["sg-0511b6cd4cbac6f1b"]
}

resource "aws_lb_target_group" "web_app_tg" {
  name     = "web-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-f4a6709d"
}


resource "aws_autoscaling_group" "web_tier_asg" {
  vpc_zone_identifier = ["subnet-0a57e2bff9477c93b", "subnet-055c19e4320fc381a"]
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  target_group_arns   = [aws_lb_target_group.web_app_tg.arn]

  launch_template {
    id      = aws_launch_template.web_tier.id
    version = "$Latest"
  }
}

resource "aws_lb" "web_tier_alb" {
  name               = "web-tier-alb"
  load_balancer_type = "application"
  security_groups    = ["sg-06ac2887a9ca7394d"]
  subnets            = ["subnet-0a57e2bff9477c93b", "subnet-055c19e4320fc381a"]
}

resource "aws_lb_listener" "web_app_front_end" {
  load_balancer_arn = aws_lb.web_tier_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }
}
