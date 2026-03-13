zone_name         = "kbnby.online"
fqdn              = "app.kbnby.online"
ami               = "ami-0e872aee57663ae2d"
instance_type     = "t3.micro"
key_name          = "my-new-key"
ssh_allowed_cidrs = ["0.0.0.0/32"]
allocate_eip      = true
vpc_cidr          = "10.0.0.0/16"
tags = {
  Project = "myapp"
  Env     = "dev"
}
