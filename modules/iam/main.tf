# modules/iam/main.tf
#
# Creates an IAM role that EC2 instances can assume, with read-only
# access to a specific S3 bucket. Includes:
#   - An assume-role policy (who can assume the role)
#   - A permissions policy (what the role can do)
#   - The role itself
#   - An instance profile (how EC2 assumes the role)
#   - A policy attachment linking them

# ---
# Data source: current AWS account ID + partition (aws / aws-cn / aws-us-gov)
# Useful for building ARNs dynamically without hardcoding.
# ---
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# ---
# Assume-role policy: allows EC2 to assume this role.
# Documented as a data source so we can jsonencode it inline.
# ---
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

# ---
# Permissions policy: what the role can do — read-only on the given S3 bucket.
# ---
data "aws_iam_policy_document" "s3_read_only" {
  statement {
    sid    = "ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid    = "ReadObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
    resources = ["${var.s3_bucket_arn}/*"]
  }
}

# ---
# The IAM role itself — EC2 will assume this.
# ---
resource "aws_iam_role" "app" {
  name               = "${var.name_prefix}-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-app-role"
    Owner = var.trainee_name
  })
}

# ---
# The IAM policy — the actual permissions document.
# ---
resource "aws_iam_policy" "s3_read_only" {
  name        = "${var.name_prefix}-s3-read-only"
  description = "Read-only access to ${var.s3_bucket_arn}"
  policy      = data.aws_iam_policy_document.s3_read_only.json

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-s3-read-only"
    Owner = var.trainee_name
  })
}

# ---
# Attach the policy to the role.
# ---
resource "aws_iam_role_policy_attachment" "s3_read_only" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}

# ---
# Instance profile — required for EC2 to use an IAM role.
# EC2 needs the profile, not the role directly.
# ---
resource "aws_iam_instance_profile" "app" {
  name = "${var.name_prefix}-app-profile"
  role = aws_iam_role.app.name

  tags = merge(var.tags, {
    Name  = "${var.name_prefix}-app-profile"
    Owner = var.trainee_name
  })
}