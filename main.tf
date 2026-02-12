terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

######################
# VPC module
######################
module "vpc" {
  source = "./modules/vpc"

  name              = "my-vpc"
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
}

######################
# IAM role & profile for EC2
######################
resource "aws_iam_role" "ec2_role" {
  name = "myapp-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_route53" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "myapp-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

######################
# EC2 module
######################
module "app_ec2" {
  source = "./modules/ec2"

  ami              = var.ami
  instance_type    = var.instance_type
  key_name         = var.key_name
  subnet_id        = module.vpc.public_subnet_id
  security_group_ids = [module.vpc.default_sg_id]
  instance_profile = aws_iam_instance_profile.ec2_profile.name
  allocate_eip     = var.allocate_eip
}

######################
# DNS module
######################
module "dns_record" {
  source          = "./modules/dns_record"
  name            = "kbnby.online"
  hosted_zone_id  = "Z0988908117FU1A1YFVP8"
  target_ip       = module.app_ec2.public_ip
}
