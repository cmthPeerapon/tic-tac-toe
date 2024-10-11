variable "TF_VAR_resource_base_name" {
  type        = string
  description = "Base name for all of the created resources"
}

variable "number_of_ec2_instance" {
  type        = number
  default     = 1
  description = "Number of instance to deploy"
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
  type = bool
  default = true
  description = "Specify whether to use spot instance or not"
}

variable "ec2_spot_instance_configurations" {
  type = object({
    instance_interruption_behavior = string
    max_price = number
    spot_instance_type = string
    valid_until = string
  })

  validation {
    condition = can(regex("^(nano|micro|small|medium)$", var.ec2_instance_type))
    error_message = "value"
  }

  validation {
    condition = can(regex("^t[34]a?\\.(nano|micro|small|medium)$", var.ec2_instance_type))
    error_message = "value"
  }

  validation {
    condition = can(regex("^t[34]a?\\.(nano|micro|small|medium)$", var.ec2_instance_type))
    error_message = "value"
  }
}

variable "use_auto_scaling_group" {
  type = bool
  default = true
  description = "Specify whether to use an Auto Scaling Group or not"
}