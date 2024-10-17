variable "TF_VAR_resource_base_name" {
  type        = string
  description = "Base name for all of the created resources"
}

variable "codedeploy_service_role_arn" {
  type        = string
  description = "ARN of the service role for the CodeDeploy EC2 deployment group"
}

variable "aws_autoscaling_group_name" {
  type        = string
  description = "Name of the deployment target Auto Scaling Group"
}