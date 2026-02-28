variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "List of CIDRs allowed to SSH into EC2 instances"
}

variable "ami" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "Key pair name for EC2"
}

variable "allocate_eip" {
  type        = bool
  description = "Whether to allocate Elastic IP for EC2"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for VPC"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags applied to resources"
}

variable "fqdn" {
  type        = string
  description = "Fully qualified domain name for DNS record"
}
