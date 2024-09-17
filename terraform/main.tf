provider "aws" {
  profile = "cmth_dev_profile"
  region = "ap-northeast-1"
}

module "infra" {
  source = "./infra"

  number_of_ec2_instance = var.number_of_ec2_instance
}

module "vpc" {
  source = "./network"
}