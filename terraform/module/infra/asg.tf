resource "aws_launch_template" "ec2_linux_server_lt" {
  count = (var.use_auto_scaling_group == true) ? 1 : 0
  name = "${var.TF_VAR_resource_base_name}-ec2-lt"
  instance_type = var.ec2_instance_type
  image_id = data.aws_ami.amazon_linux_2023.id
  vpc_security_group_ids = var.security_group_ids[*]
  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop"
      max_price = var.ec2_spot_instance_max_price
    }
  }

  tags = {
    "Name"           = "${var.TF_VAR_resource_base_name}-ec2-${count.index + 1}"
    "CmBillingGroup" = ""
  }
}

resource "aws_autoscaling_group" "ec2_asg" {
  
}