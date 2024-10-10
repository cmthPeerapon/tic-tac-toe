output "azs" {
  value = data.aws_availability_zones.available.names
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "security_groups" {
  value = aws_security_group.ec2_security_group.id
}