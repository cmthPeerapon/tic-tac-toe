provider "aws" {
  profile = "cmth_dev_profile"
  region  = var.region
  # skip_credentials_validation = true
  # skip_metadata_api_check = true
  # skip_requesting_account_id = true

  # endpoints {
  #   ec2 = "http://localhost:4566"
  # }
}

locals {
  default_subnet_id = var.is_private == true ? module.network.private_subnet_ids[0] : module.network.public_subnet_ids[0]
}

module "iam" {
  source = "./module/iam"
}

module "network" {
  source                       = ".module/network"
  region                       = var.region
  security_group_inbound_rules = var.security_group_inbound_rules
}

module "infra" {
  source                 = ".module/infra"
  number_of_ec2_instance = var.number_of_ec2_instance
  subnet_id              = coalesce(var.subnet_id, local.default_subnet_id)
  security_groups        = length(var.security_groups) == 0 ? module.network.security_groups[*] : var.security_groups
}