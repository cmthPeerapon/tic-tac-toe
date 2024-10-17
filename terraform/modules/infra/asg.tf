locals {
  resource_to_tag = {
    "ec2"    = "instance"
    "volume" = "volume"
    "eni"    = "network-interface"
  }
}

resource "aws_launch_template" "ec2_linux_server_lt" {
  count                  = (var.use_auto_scaling_group == true) ? 1 : 0
  name                   = "${var.TF_VAR_resource_base_name}-ec2-lt"
  instance_type          = var.ec2_instance_type
  image_id               = data.aws_ami.amazon_linux_2023.id
  update_default_version = true
  user_data              = base64encode(templatefile("${path.root}/templates/user_data/install_codedeploy_agent.sh", { region = var.TF_VAR_region }))

  network_interfaces {
    subnet_id       = var.subnet_id
    security_groups = var.security_group_ids[*]
  }

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  dynamic "tag_specifications" {
    for_each = local.resource_to_tag
    content {
      resource_type = tag_specifications.value
      tags = {
        "Name" : "${var.TF_VAR_resource_base_name}-${tag_specifications.key}"
      }
    }
  }

  dynamic "instance_market_options" {
    for_each = (var.use_spot_instance == true) ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        spot_instance_type             = "one-time"
        instance_interruption_behavior = "terminate"
        max_price                      = var.spot_instance_max_price
      }
    }
  }

  tags = {
    "Name"           = "${var.TF_VAR_resource_base_name}-ec2-linux-lt"
    "CmBillingGroup" = ""
  }
}

resource "aws_autoscaling_group" "ec2_linux_server_asg" {
  count            = (var.use_auto_scaling_group == true) ? 1 : 0
  name             = "${var.TF_VAR_resource_base_name}-ec2-linux-asg"
  min_size         = var.asg_configurations.min_size
  max_size         = var.asg_configurations.max_size
  desired_capacity = var.asg_configurations.desired_capacity
  launch_template {
    id      = aws_launch_template.ec2_linux_server_lt[0].id
    version = "$Latest"
  }
}