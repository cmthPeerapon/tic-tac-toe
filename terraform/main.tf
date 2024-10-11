provider "aws" {
  profile = "cmth_dev_profile"
  region  = var.TF_VAR_region
  # skip_credentials_validation = true
  # skip_metadata_api_check = true
  # skip_requesting_account_id = true

  # endpoints {
  #   ec2 = "http://localhost:4566"
  #   iam = "http://localhost:4566"
  # }
}

locals {
  default_subnet_id = var.is_private == true ? module.network.private_subnet_ids[0] : module.network.public_subnet_ids[0]
}

module "iam" {
  source                    = "./module/iam"
  TF_VAR_resource_base_name = var.TF_VAR_resource_base_name
}

module "network" {
  source                    = "./module/network"
  TF_VAR_resource_base_name = var.TF_VAR_resource_base_name
  TF_VAR_region             = var.TF_VAR_region

  security_group_inbound_rules = var.security_group_inbound_rules
}

module "infra" {
  source                    = "./module/infra"
  TF_VAR_resource_base_name = var.TF_VAR_resource_base_name

  number_of_ec2_instance   = var.number_of_ec2_instance
  subnet_id                = coalesce(var.subnet_id, local.default_subnet_id)
  security_group_ids       = length(var.security_group_ids) == 0 ? module.network.security_group_id[*] : var.security_group_ids
  ec2_instance_profile_name = coalesce(var.ec2_instance_profile_name, module.iam.ec2_instance_profile_name)
}