variable "ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair to use"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where EC2 will be launched"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to assign to EC2"
}

variable "instance_profile" {
  type        = string
  description = "IAM instance profile to attach to EC2"
}

variable "allocate_eip" {
  type        = bool
  description = "Whether to allocate an Elastic IP for the instance"
  default     = false
}

variable "fqdn" {
  type        = string
  description = "Fully qualified domain name for the EC2 instance (used in userdata for website)"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to the EC2 instance"
  default     = {}
}

variable "user_data" {
  type        = string
  description = "Rendered user data script for the EC2 instance"
}
