data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codedeploy_asg" {
  statement {
    sid    = "codeDeployASG"
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:CreateTags",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy" "codedeploy_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role" "codedeploy_service_role" {
  name               = "${var.TF_VAR_resource_base_name}-codedeploy-service-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_service_role_attachment" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = data.aws_iam_policy.codedeploy_role.arn
}

# Create and attach an additional inline policy to the 'aws_iam_role.codedeploy_service_role'
resource "aws_iam_role_policy" "codedeploy_asg_policy" {
  name   = "codedeploy-asg-policy"
  policy = data.aws_iam_policy_document.codedeploy_asg.json
  role   = aws_iam_role.codedeploy_service_role.name
}