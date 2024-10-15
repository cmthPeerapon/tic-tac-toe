variable "TF_VAR_resource_base_name" {
  type        = string
  description = "Base name for all of the created resources"
}

variable "TF_VAR_region" {
  type        = string
  description = "The region your infrastructure will be deployed in"
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

variable "use_auto_scaling_group" {
  type        = bool
  default     = true
  description = "Specify whether to use an Auto Scaling Group or not"
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