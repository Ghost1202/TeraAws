locals {
  project = "myapp"
  env     = terraform.workspace
  name    = "${local.project}-${local.env}"

  user_data = templatefile("${path.root}/assets/userdata.tpl", {
    fqdn = var.fqdn
  })
}

module "vpc" {
  source            = "./modules/vpc"
  name              = local.name
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
  vpc_cidr          = var.vpc_cidr
  tags              = var.tags
}

module "app_ec2" {
  source            = "./modules/ec2"
  name              = local.name
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  vpc_id            = module.vpc.vpc_id
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
  allocate_eip      = var.allocate_eip
  user_data         = local.user_data
  tags              = var.tags
}

data "aws_route53_zone" "main" {
  name         = var.zone_name
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.fqdn
  type    = "A"
  ttl     = 300
  records = [module.app_ec2.public_ip]
}
