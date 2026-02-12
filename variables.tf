variable "aws_region" {}
variable "ssh_allowed_cidrs" {
  type = list(string)
}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "allocate_eip" {
  type = bool
}
variable "fqdn" {}
variable "hosted_zone_id" {}
