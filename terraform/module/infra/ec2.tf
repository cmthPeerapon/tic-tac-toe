data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "ec2_linux_server" {
  count           = var.number_of_ec2_instance
  ami             = data.aws_ami.amazon_linux_2023.image_id
  instance_type   = var.ec2_instance_type
  subnet_id       = var.subnet_id
  vpc_security_group_ids = var.security_groups[*]
  tags = {
    "Name"           = "${var.ec2_instance_name}-${count.index + 1}"
    "CmBillingGroup" = ""
  }
}