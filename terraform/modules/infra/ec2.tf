resource "aws_instance" "ec2_linux_server" {
  count                  = (var.use_auto_scaling_group == true) ? 0 : var.number_of_ec2_instance
  ami                    = data.aws_ami.amazon_linux_2023.image_id
  instance_type          = var.ec2_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids[*]
  iam_instance_profile   = var.ec2_instance_profile_name

  dynamic "instance_market_options" {
    for_each = (var.use_spot_instance == true) ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        spot_instance_type             = var.spot_instance_configurations.spot_instance_type
        instance_interruption_behavior = var.spot_instance_configurations.instance_interruption_behavior
        max_price                      = var.spot_instance_configurations.max_price
        valid_until                    = var.spot_instance_configurations.valid_until
      }
    }
  }

  tags = {
    "Name"           = "${var.TF_VAR_resource_base_name}-ec2-${count.index + 1}"
    "CmBillingGroup" = ""
  }
}