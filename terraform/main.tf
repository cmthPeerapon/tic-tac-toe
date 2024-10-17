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
  source                    = "./modules/iam"
  TF_VAR_resource_base_name = var.TF_VAR_resource_base_name
  TF_VAR_region             = var.TF_VAR_region
}

module "network" {
  source                    = "./modules/network"
  TF_VAR_resource_base_name = var.TF_VAR_resource_base_name
  TF_VAR_region             = var.TF_VAR_region

  cidr_block                    = var.cidr_block
  number_of_public_subnets      = var.number_of_public_subnets
  public_subnet_cidr_blocks     = var.public_subnet_cidr_blocks
  number_of_private_subnets     = var.number_of_private_subnets
  private_subnet_cidr_blocks    = var.private_subnet_cidr_blocks
  security_group_inbound_rules  = var.security_group_inbound_rules
  security_group_outbound_rules = var.security_group_outbound_rules
}

module "infra" {
  source                    = "./modules/infra"
  TF_VAR_resource_base_name = var.TF_VAR_resource_base_name
  TF_VAR_region             = var.TF_VAR_region

  use_auto_scaling_group    = var.use_auto_scaling_group
  number_of_ec2_instance    = var.number_of_ec2_instance
  subnet_id                 = coalesce(var.subnet_id, local.default_subnet_id)
  security_group_ids        = length(var.security_group_ids) == 0 ? module.network.security_group_id[*] : var.security_group_ids
  is_private                = var.is_private
  ec2_instance_profile_name = coalesce(var.ec2_instance_profile_name, module.iam.ec2_instance_profile_name)
  use_spot_instance         = var.use_spot_instance
  spot_instance_max_price   = var.spot_instance_max_price
  asg_configurations        = var.asg_configurations
}

module "deploy" {
  source                    = "./modules/deploy"
  TF_VAR_resource_base_name = var.TF_VAR_resource_base_name

  codedeploy_service_role_arn = module.iam.codedeploy_service_role_arn
  aws_autoscaling_group_name  = module.infra.aws_autoscaling_group_name
}