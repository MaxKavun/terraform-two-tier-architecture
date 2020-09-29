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

module "network" {
  source = "./network"
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
  vpc_security_group_ids = [module.network.web_tier_sg]
}

resource "aws_lb_target_group" "web_app_tg" {
  name     = "web-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.main_vpc
}


resource "aws_autoscaling_group" "web_tier_asg" {
  vpc_zone_identifier = [module.network.subnet_a, module.network.subnet_b]
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
  security_groups    = [module.network.alb_sg]
  subnets            = [module.network.subnet_a, module.network.subnet_b]
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
