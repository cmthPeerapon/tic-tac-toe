resource "aws_codedeploy_app" "codedeploy_ec2_app" {
  compute_platform = "Server"
  name             = "${var.TF_VAR_resource_base_name}-ec2-app"

  tags = {
    "CmBillingGroup" = ""
  }
}

resource "aws_codedeploy_deployment_group" "codedeploy_ec2_deployment_group" {
  app_name                    = aws_codedeploy_app.codedeploy_ec2_app.name
  deployment_group_name       = "${var.TF_VAR_resource_base_name}-ec2-deployment_group"
  service_role_arn            = var.codedeploy_service_role_arn
  autoscaling_groups          = [var.aws_autoscaling_group_name]
  outdated_instances_strategy = "UPDATE"

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = {
    "CmBillingGroup" = ""
  }
}