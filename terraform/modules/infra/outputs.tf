output "amazon_linux_2023" {
  value = aws_instance.ec2_linux_server[*].id
}

output "aws_autoscaling_group_name" {
  value = aws_autoscaling_group.ec2_linux_server_asg[0].name
}