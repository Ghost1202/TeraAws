output "ec2_public_ip" {
  value = module.app_ec2.public_ip
}

output "ec2_id" {
  value = module.app_ec2.id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}
