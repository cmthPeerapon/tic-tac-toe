# ==============================================================================
# Module: infra
# Description: Sets up EC2, ECS, and related infrastructure resources
# ==============================================================================

variable "number_of_ec2_instance" {
  type = number
  default = 1
  description = "Number of instance to deploy"
}

variable "ec2_instance_name" {
  type = string
  default = "peerapon-test"
  description = "Name of the instance"
}

variable "ec2_instance_type" {
  type = string
  default = "t3.small"
  validation {
    condition = can(regex("^t[34]a?\\.(nano|micro|small|medium)$", var.ec2_instance_type))
    error_message = "Invalid instance type. Only t3 and t4g instances of size nano, micro, small, or medium are allowed."
  }
}

# ==============================================================================
# Module: Networking
# Description: Sets up VPC, subnets, and related networking resources
# ==============================================================================

