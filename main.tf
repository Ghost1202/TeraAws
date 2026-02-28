module "vpc" {
  source           = "./modules/vpc"
  name             = local.name
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
  vpc_cidr         = var.vpc_cidr
  tags             = var.tags
}

resource "aws_iam_role" "ec2_role" {
  name = local.name
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

resource "aws_iam_instance_profile" "ec2_profile" {
  name = local.name
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "ec2_sg" {
  name        = "${local.name}-sg"
  description = "Allow SSH"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

module "app_ec2" {
  source           = "./modules/ec2"
  ami              = var.ami
  instance_type    = var.instance_type
  key_name         = var.key_name
  subnet_id        = module.vpc.public_subnet_ids[0]
  security_group_ids = [aws_security_group.ec2_sg.id]
  instance_profile = aws_iam_instance_profile.ec2_profile.name
  allocate_eip     = var.allocate_eip
  fqdn             = var.fqdn
  tags             = var.tags
}

data "aws_route53_zone" "main" {
  name         = var.fqdn
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.main.id
  name    = var.fqdn
  type    = "A"
  ttl     = 300
  records = [module.app_ec2.public_ip]
}
