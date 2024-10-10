ec2_instance_name = "peerapon-test-ec2"
ec2_instance_type = "t3.small"

region   = "ap-northeast-1"
vpc_name = "peerapon"
security_group_inbound_rules = {
  "allow_https" = {
    cidr_ipv4   = "3.112.23.0/29"
    from_port   = 443
    ip_protocol = "tcp"
    to_port     = 443
  },
  "allow_http" = {
    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 80
    ip_protocol = "tcp"
    to_port     = 80
  },
  "allow_ssh" = {
    cidr_ipv4   = "104.28.214.146/32"
    from_port   = 22
    ip_protocol = "tcp"
    to_port     = 22
  }
}