variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "instance_profile" {}
variable "allocate_eip" {
  type = bool
}
