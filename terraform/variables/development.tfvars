TF_VAR_region             = "ap-northeast-1"
TF_VAR_resource_base_name = "peerapon-test"

ec2_instance_type       = "t3.small"
spot_instance_max_price = 0.01
asg_configurations = {
  min_size         = 1
  max_size         = 2
  desired_capacity = 2
}

security_group_inbound_rules = {
  "allow_eip_ssh" = {
    cidr_ipv4   = "3.112.23.0/29"
    from_port   = 22
    ip_protocol = "tcp"
    to_port     = 22
  },
  "allow_http" = {
    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
  },
  "allow_ssh" = {
    cidr_ipv4   = "101.108.71.45/32"
    from_port   = 22
    ip_protocol = "tcp"
    to_port     = 22
  }
}