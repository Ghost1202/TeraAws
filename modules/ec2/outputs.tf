output "public_ip" {
  value = coalesce(
    try(aws_eip.this[0].public_ip, null),
    aws_instance.this.public_ip
  )
}

