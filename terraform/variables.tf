# ==============================================================================
# Global variable
# Description: Global variables that will be used across the project
# ==============================================================================

variable "TF_VAR_resource_base_name" {
  type        = string
  default     = "terraform"
  description = "Base name for all of the created resources"
}

variable "TF_VAR_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "The region your infrastructure will be deployed in"
}

# ==============================================================================
# Module: infra
# Description: Sets up EC2, ECS, and related infrastructure resources
# ==============================================================================

variable "use_auto_scaling_group" {
  type        = bool
  default     = true
  description = "Specify whether to use an Auto Scaling Group or not"
}

variable "number_of_ec2_instance" {
  type        = number
  default     = 1
  description = "Number of instance to deploy. If the 'use_auto_scaling_group' is set to true, this variable will be ignored"
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

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ids where the EC2 resides"
}

variable "is_private" {
  type        = bool
  default     = false
  description = "Specify whether the EC2 should be put in a private subnet or not"
}

variable "ec2_instance_profile_name" {
  type        = string
  default     = ""
  description = "ARN of an instance profile to attach to the EC2"
}

variable "use_spot_instance" {
  type        = bool
  default     = true
  description = "Specify whether to use spot instance or not"
}

variable "spot_instance_max_price" {
  type        = number
  description = "Max price for EC2 spot instance"
}

variable "asg_configurations" {
  type = object({
    min_size         = number
    max_size         = number
    desired_capacity = number
  })

  validation {
    condition     = alltrue([var.asg_configurations.min_size >= 0, var.asg_configurations.max_size >= 0, var.asg_configurations.desired_capacity >= 0])
    error_message = "All the min_size, max_size, and desired_capacity value must be greater than 0"
  }

  validation {
    condition     = alltrue([var.asg_configurations.min_size <= var.asg_configurations.max_size, var.asg_configurations.min_size <= var.asg_configurations.desired_capacity])
    error_message = "The min_size value must not exceed the max_size and desired_capacity value"
  }

  validation {
    condition     = alltrue([var.asg_configurations.max_size <= var.asg_configurations.desired_capacity])
    error_message = "The max_size value must not exceed the desired_capacity value"
  }

  default = {
    min_size         = 1
    max_size         = 1
    desired_capacity = 1
  }
  description = "Configurations for the Auto Scaling Group"
}

# ==============================================================================
# Module: network
# Description: Sets up VPC, subnets, and related networking resources
# ==============================================================================

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block of the VPC"
}

variable "number_of_public_subnets" {
  type        = number
  default     = 2
  description = "Number of public subnets (AZs) inside the VPC"
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20"]
  validation {
    condition     = length(var.public_subnet_cidr_blocks) == var.number_of_public_subnets
    error_message = "The number of specified public subnet CIDR blocks must match the 'number_of_public_subnets' value"
  }
}

variable "number_of_private_subnets" {
  type        = number
  default     = 2
  description = "Number of private subnets (AZs) inside the VPC"
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.128.0/20", "10.0.144.0/20"]
  validation {
    condition     = length(var.private_subnet_cidr_blocks) == var.number_of_private_subnets
    error_message = "The number of specified private subnet CIDR blocks must match the 'number_of_private_subnets' value"
  }
}

variable "security_group_inbound_rules" {
  type = map(object({
    cidr_ipv4                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = any
    to_port                      = optional(number)
    description                  = optional(string)
  }))
  validation {
    condition = alltrue([
      for rule in var.security_group_inbound_rules : (
        (rule.cidr_ipv4 != null ? 1 : 0) +
        (rule.prefix_list_id != null ? 1 : 0) +
        (rule.referenced_security_group_id != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Only 'cidr_ipv4', 'prefix_list_id', or 'referenced_security_group_id' can be specified at a time"
  }
}

variable "security_group_outbound_rules" {
  type = map(object({
    cidr_ipv4                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = number
    to_port                      = optional(number)
    description                  = optional(string)
  }))
  default = {
    "allow_all_traffic" = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = -1
    }
  }
  validation {
    condition = alltrue([
      for rule in var.security_group_outbound_rules : (
        (rule.cidr_ipv4 != null ? 1 : 0) +
        (rule.prefix_list_id != null ? 1 : 0) +
        (rule.referenced_security_group_id != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Only 'cidr_ipv4', 'prefix_list_id', or 'referenced_security_group_id' can be specified at a time"
  }
}