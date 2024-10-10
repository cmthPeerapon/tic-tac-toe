variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "The region your infrastructure will be deployed in"
}

variable "vpc_name" {
  type        = string
  default     = "peerapon-test-vpc"
  description = "Name of the VPC"
}

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

variable "security_group_name" {
  type        = string
  default     = "peerapon-test-sg"
  description = "Name of the security group to be attached to the EC2"
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