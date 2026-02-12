resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.instance_profile

  associate_public_ip_address = false

  tags = {
    Name = "App EC2"
  }
}

resource "aws_eip" "this" {
  count      = var.allocate_eip ? 1 : 0
  instance   = aws_instance.this.id
  domain     = "vpc"
}

output "id" {
  value = aws_instance.this.id
}

