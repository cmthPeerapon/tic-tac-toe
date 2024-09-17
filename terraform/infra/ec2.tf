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

resource "aws_instance" "ec2-linux-server" {
  ami = data.aws_ami.amazon_linux_2023.image_id
  tags = {
    "Name" = var.ec2_instance_name
    "CmBillingGroup" = ""
  }
  instance_type = "t3.large"
}