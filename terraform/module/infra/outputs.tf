output "amazon_linux_2023" {
  value = aws_instance.ec2_linux_server[*].id
}