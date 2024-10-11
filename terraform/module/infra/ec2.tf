resource "aws_instance" "ec2_linux_server" {
  count                  = var.number_of_ec2_instance
  ami                    = data.aws_ami.amazon_linux_2023.image_id
  instance_type          = var.ec2_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids[*]
  tags = {
    "Name"           = "${var.TF_VAR_resource_base_name}-ec2-${count.index + 1}"
    "CmBillingGroup" = ""
  }
  iam_instance_profile = var.ec2_instance_profile_name
}