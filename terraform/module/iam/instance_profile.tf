data "aws_iam_policy_document" "assume_role" {
  
}

data "aws_iam_policy_document" "policy" {
  
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.ec2_instance_name}-profile"
  role = aws_iam_role.ec2_instance_profile_role.name
}

resource "aws_iam_role" "ec2_instance_profile_role" {
  name = "${var.ec2_instance_name}-role"
  assume_role_policy = 
}

resource "aws_iam_policy" "ec2_instance_profile_policy" {
  name = "${var.ec2_instance_name}-policy"
  policy = 
}

resource "aws_iam_role_policy_attachment" "ec2_instance_profile_attachment" {
  role = aws_iam_role.ec2_instance_profile_role.name
  policy_arn = aws_iam_policy.ec2_instance_profile_policy.arn
}