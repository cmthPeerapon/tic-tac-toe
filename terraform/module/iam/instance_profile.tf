data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ec2_instance_profile_role" {
  name               = "${var.TF_VAR_resource_base_name}-ec2-profile-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_instance_profile_attachment" {
  role       = aws_iam_role.ec2_instance_profile_role.name
  policy_arn = data.aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.TF_VAR_resource_base_name}-ec2-profile"
  role = aws_iam_role.ec2_instance_profile_role.name
}