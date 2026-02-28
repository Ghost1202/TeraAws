variable "name" {
  type        = string
  description = "Name prefix for VPC resources"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "Allowed CIDRs for SSH access"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all VPC resources"
  default     = {}
}
