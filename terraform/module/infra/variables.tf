variable "number_of_ec2_instance" {
  type        = number
  default     = 1
  description = "Number of instance to deploy"
}

variable "ec2_instance_name" {
  type        = string
  default     = "peerapon-test"
  description = "Name of the instance"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.small"
  validation {
    condition     = can(regex("^t[34]a?\\.(nano|micro|small|medium)$", var.ec2_instance_type))
    error_message = "Invalid instance type. Only t3 and t4g instances of size nano, micro, small, or medium are allowed."
  }
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Subnet id where the EC2 resides"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "Security group ids where the EC2 resides"
}

variable "is_private" {
  type        = bool
  default     = false
  description = "Specify whether the EC2 should be put in a private subnet or not"
}