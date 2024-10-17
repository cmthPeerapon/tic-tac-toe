data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "get_codedeploy_agent" {
  statement {
    sid    = "getCodeDeployAgent"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = ["arn:aws:s3:::aws-codedeploy-${var.TF_VAR_region}/*"]
  }
}

data "aws_iam_policy" "ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ec2_instance_profile_role" {
  name               = "${var.TF_VAR_resource_base_name}-ec2-profile-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_instance_profile_attachment" {
  role       = aws_iam_role.ec2_instance_profile_role.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
}

# Create and attach an additional inline policy to the 'aws_iam_role.ec2_instance_profile_role'
resource "aws_iam_role_policy" "get_codedeploy_agent_policy" {
  name   = "get-codedeploy-agent-policy"
  policy = data.aws_iam_policy_document.get_codedeploy_agent.json
  role   = aws_iam_role.ec2_instance_profile_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.TF_VAR_resource_base_name}-ec2-profile"
  role = aws_iam_role.ec2_instance_profile_role.name
}