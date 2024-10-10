data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "region-name"
    values = [var.region]
  }
}

locals {
  available_az_no = length(data.aws_availability_zones.available.names)
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" : var.vpc_name
    "CmBillingGroup" : ""
  }
}

resource "aws_subnet" "public_subnets" {
  count                                       = var.number_of_public_subnets
  vpc_id                                      = aws_vpc.main_vpc.id
  cidr_block                                  = var.public_subnet_cidr_blocks[count.index]
  availability_zone                           = data.aws_availability_zones.available.names[count.index % local.available_az_no]
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    "CmBillingGroup" : ""
  }
}

resource "aws_subnet" "private_subnets" {
  count                                       = var.number_of_private_subnets
  vpc_id                                      = aws_vpc.main_vpc.id
  cidr_block                                  = var.private_subnet_cidr_blocks[count.index]
  availability_zone                           = data.aws_availability_zones.available.names[count.index % local.available_az_no]
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    "CmBillingGroup" : ""
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "CmBillingGroup" : ""
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "CmBillingGroup" : ""
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "CmBillingGroup" : ""
  }
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = var.number_of_public_subnets
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = var.number_of_private_subnets
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "ec2_security_group" {
  name   = var.security_group_name
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" : var.security_group_name
    "CmBillingGroup" : ""
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_rule" {
  for_each                     = var.security_group_inbound_rules
  security_group_id            = aws_security_group.ec2_security_group.id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.ip_protocol == -1 ? null : each.value.from_port
  to_port                      = each.value.ip_protocol == -1 ? null : each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  description                  = coalesce(each.value.description, each.key, "Managed by Terraform")
}

resource "aws_vpc_security_group_egress_rule" "outbound_rule" {
  for_each                     = var.security_group_outbound_rules
  security_group_id            = aws_security_group.ec2_security_group.id
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.ip_protocol == -1 ? null : each.value.from_port
  to_port                      = each.value.ip_protocol == -1 ? null : each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  description                  = coalesce(each.value.description, each.key, "Managed by Terraform")
}