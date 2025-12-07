

resource "aws_iam_role" "ec2_role" {
  name = "3tier-ec2-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "3tier-ec2-role-${var.environment}"
    Project = "3-tier-Infra"
  }
}

# SSM access - Session Manager
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# S3 read access to get code/artifacts
resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# instance profile for ASG (backend + frontend will use this)
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "3tier-ec2-instance-profile-${var.environment}"
  role = aws_iam_role.ec2_role.name
}
