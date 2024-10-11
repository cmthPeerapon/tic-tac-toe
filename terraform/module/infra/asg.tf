resource "aws_launch_template" "ec2_linux_server_lt" {
  count = (var.use_spot_instance == )
  name = "${var.TF_VAR_resource_base_name}-ec2-lt"
  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop"
      max_price = var.ec2_spot_instance_max_price
    }
  }
}

resource "aws_autoscaling_group" "ec2_asg" {
  
}