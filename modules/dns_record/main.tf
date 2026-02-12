resource "aws_route53_record" "this" {
  zone_id = var.hosted_zone_id
  name    = var.name
  type    = "A"
  ttl     = 300
  records = [var.target_ip]
}
